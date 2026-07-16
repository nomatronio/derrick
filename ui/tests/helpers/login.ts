import { authenticateSession } from 'ember-simple-auth/test-support';

export default async function login(derrickToken = 'default-test-token-value'): Promise<void> {
  return await authenticateSession({ token: derrickToken });
}

export function setupSession(hooks: NestedHooks): void {
  hooks.beforeEach(() => login());
}
