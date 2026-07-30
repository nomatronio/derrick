package ssh

import (
	"bytes"
	"context"
	"crypto/rand"
	"crypto/rsa"
	"crypto/subtle"
	"fmt"
	"net"
	"testing"
	"time"

	"github.com/gliderlabs/ssh"
	"github.com/hashicorp/go-hclog"
	"github.com/stretchr/testify/require"
	gossh "golang.org/x/crypto/ssh"
)

func TestServer(t *testing.T) {
	hostkey, err := rsa.GenerateKey(rand.Reader, 2048)
	require.NoError(t, err)

	userkey, err := rsa.GenerateKey(rand.Reader, 2048)
	require.NoError(t, err)

	hostSigner, err := gossh.NewSignerFromKey(hostkey)
	require.NoError(t, err)

	userSigner, err := gossh.NewSignerFromKey(userkey)
	require.NoError(t, err)

	check := func(ctx ssh.Context, inputKey ssh.PublicKey) bool {
		return ssh.KeysEqual(inputKey, userSigner.PublicKey())
	}

	l, err := net.Listen("tcp", "127.0.0.1:0")
	require.NoError(t, err)

	var server *ssh.Server
	ready := make(chan struct{})
	serveDone := make(chan struct{})

	ctx := context.Background()

	go func() {
		defer close(serveDone)
		// Do not pass &server here: createHandler shuts the server down after
		// the first command, which can race with the client reading stdout.
		_ = ssh.Serve(l,
			createHandler(ctx, hclog.L(), nil),
			ssh.Option(func(serv *ssh.Server) error {
				server = serv
				serv.PublicKeyHandler = check
				serv.AddHostKey(hostSigner)
				close(ready)
				return nil
			}),
		)
	}()

	t.Cleanup(func() {
		if server != nil {
			_ = server.Shutdown(context.Background())
		}
		_ = l.Close()
		select {
		case <-serveDone:
		case <-time.After(5 * time.Second):
			t.Log("timed out waiting for ssh server to stop")
		}
	})

	select {
	case <-ready:
	case <-time.After(5 * time.Second):
		t.Fatal("ssh server did not become ready")
	}

	var cfg gossh.ClientConfig
	cfg.User = "derrick"
	cfg.Auth = []gossh.AuthMethod{
		gossh.PublicKeys(userSigner),
	}

	expectedHost := hostSigner.PublicKey().Marshal()

	cfg.HostKeyCallback = func(hostname string, remote net.Addr, key gossh.PublicKey) error {
		// Weirdly this is how you make sure the host key is what you think it should be.
		// Think of this as where normal ssh client would do the "Do you want to trust this
		// host?" popup.
		if subtle.ConstantTimeCompare(expectedHost, key.Marshal()) == 1 {
			return nil
		}

		return fmt.Errorf("wrong host key detected")
	}

	cfg.Timeout = 10 * time.Second

	client, err := gossh.Dial("tcp", l.Addr().String(), &cfg)
	require.NoError(t, err)
	t.Cleanup(func() { _ = client.Close() })

	sess, err := client.NewSession()
	require.NoError(t, err)
	t.Cleanup(func() { _ = sess.Close() })

	stdin, err := sess.StdinPipe()
	require.NoError(t, err)
	require.NoError(t, stdin.Close())

	var buf bytes.Buffer
	sess.Stdout = &buf

	err = sess.Run("sh -c 'echo hello'")
	require.NoError(t, err)
	require.Equal(t, "hello\n", buf.String())
}
