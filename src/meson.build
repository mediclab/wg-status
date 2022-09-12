sources = [
  'main.vala',
  'application.vala',
  'nmcli.vala',
  'about.vala',
]

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gtk+-3.0'),
    dependency('appindicator3-0.1'),
    dependency('gee-0.8'),
    dependency('libnotify'),
    dependency('libnm'),
]

gnome = import('gnome')

sources += gnome.compile_resources('wg_status-resources',
  'wg_status_vala.gresource.xml',
  c_name: 'wg_status'
)

executable('wg-status', sources, dependencies: dependencies, install: true)