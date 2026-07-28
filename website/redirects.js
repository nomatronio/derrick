module.exports = [
  {
    source: '/waypoint/docs/:path*',
    destination: '/derrick/docs/:path*',
    permanent: true,
  },
  {
    source: '/waypoint/plugins/:path*',
    destination: '/derrick/plugins/:path*',
    permanent: true,
  },
  {
    source: '/waypoint/commands/:path*',
    destination: '/derrick/commands/:path*',
    permanent: true,
  },
  {
    source: '/derrick/docs/kubernetes/:path*',
    destination: '/derrick/docs/platforms/kubernetes/:path*',
    permanent: true,
  },
  {
    source: '/derrick/docs/glossary',
    destination: '/derrick/docs/resources/glossary',
    permanent: true,
  },
  {
    source: '/derrick/docs/roadmap',
    destination: '/derrick/docs/resources/roadmap',
    permanent: true,
  },
  {
    source: '/derrick/docs/troubleshooting',
    destination: '/derrick/docs/resources/troubleshooting',
    permanent: true,
  },
  {
    source: '/derrick/docs/internals/:path*',
    destination: '/derrick/docs/resources/internals/:path*',
    permanent: true,
  },
]
