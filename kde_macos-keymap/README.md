# KDE macOS Keymap

Prototipo para Debian 13 con KDE Plasma en Wayland y un teclado Apple. Convierte solo atajos concretos de `⌘` (la tecla `Super`) a sus equivalentes `Ctrl`; **no intercambia los modificadores globalmente**.

Así `Ctrl+C` conserva su comportamiento normal —incluido SIGINT en terminal— y los atajos de KWin con `Meta`, como `Meta+Flechas` y `Meta+Tab`, permanecen disponibles.

## Requisitos

- KDE Plasma en una sesión Wayland.
- `systemd --user`, `sudo`, `udev` y el módulo de kernel `uinput`.

Si `xremap` no existe, `apply` instala automáticamente la variante oficial para KDE, en el directorio del usuario. Detecta `x86_64` y `aarch64`, descarga la versión fijada `0.15.13` mediante HTTPS y comprueba el SHA-256 antes de extraerla. Si faltan `curl` o `unzip`, los instala con APT y solicitará `sudo`.

No sobrescribe un xremap existente ni instala binarios de terceros como root. La copia administrada queda en `~/.local/lib/kde-macos-keymap/`.

Si la descarga, extracción o ejecución inicial falla, el script conserva los archivos temporales en `~/.local/state/kde-macos-keymap/download-failures/` e imprime la ruta exacta y el error original para facilitar el diagnóstico.

## Atajos de esta primera iteración

En todas las aplicaciones, incluidos los terminales:

- `⌘Tab` → `Alt+Tab`: siguiente aplicación/ventana de KWin.
- `⌘⇧Tab` → `Alt+⇧Tab`: aplicación/ventana anterior de KWin.

Fuera de terminales, se mapean estos atajos:

`⌘C`, `⌘X`, `⌘V`, `⌘A`, `⌘Z`, `⌘⇧Z`, `⌘F`, `⌘S`, `⌘⇧S`, `⌘O`, `⌘N`, `⌘W`, `⌘P`.

En Konsole, Alacritty, kitty, WezTerm y GNOME Terminal solamente:

- `⌘C` → `Ctrl+Shift+C`
- `⌘V` → `Ctrl+Shift+V`

Los nombres de las aplicaciones se validarán en la VM con los registros de xremap; KDE Wayland los muestra al activar una regla con filtro de aplicación.

## Instalación rápida

Desde una máquina Debian con KDE Plasma en Wayland:

```bash
git clone https://github.com/ricardoqsx/scripts.git && cd scripts/kde_macos-keymap && chmod +x ./kde-macos-keymap && ./kde-macos-keymap apply
```

El comando descarga el repositorio, entra en este proyecto y ejecuta la instalación. `apply` instala xremap automáticamente si hace falta y pedirá la contraseña de `sudo` para los cambios de sistema necesarios.

Si el repositorio ya está clonado:

```bash
chmod +x ./kde-macos-keymap && ./kde-macos-keymap apply
```

Para actualizar los atajos tras obtener una versión nueva del repositorio, sin reinstalar ni modificar permisos:

```bash
git pull && ./kde-macos-keymap update
```

## Uso en la máquina virtual

Primero, crear un snapshot limpio de Debian 13 Live KDE instalado y entrar en **Plasma (Wayland)**.

```bash
chmod +x kde-macos-keymap
./kde-macos-keymap status
./kde-macos-keymap --dry-run apply
./kde-macos-keymap apply
```

`apply` crea un respaldo antes de cambiar nada. Creará exclusivamente:

- `~/.config/kde-macos-keymap/xremap.yml`
- `~/.config/systemd/user/kde-macos-keymap.service`
- `/etc/udev/rules.d/99-kde-macos-keymap-uinput.rules`
- `/etc/modules-load.d/kde-macos-keymap.conf`

También añade el usuario actual al grupo `input` solo si no estaba en él. Hay que cerrar sesión y volver a entrar antes de probar.

Para revertir los cambios administrados por el proyecto:

```bash
./kde-macos-keymap restore
```

`restore` detiene el servicio y elimina solo los archivos propios. Si el grupo `input` fue añadido por el script, también elimina esa pertenencia. Los respaldos permanecen en `~/.local/state/kde-macos-keymap/backups/`.

Para eliminar además la copia de xremap descargada por el script:

```bash
./kde-macos-keymap restore --purge
```

Los paquetes APT instalados como prerequisito se conservan: eliminarlos automáticamente podría afectar a otros programas.

## Lista de pruebas

1. En Konsole, ejecutar `sleep 60` y confirmar que `Ctrl+C` lo interrumpe.
2. En Firefox o Dolphin, confirmar copia/pega con `⌘C` y `⌘V`.
3. Confirmar buscar, guardar, deshacer/rehacer y abrir con los atajos indicados.
4. Confirmar `Meta+Flechas` y `Meta+Tab` de KWin.
5. Ejecutar `restore`, cerrar sesión y confirmar que todos los atajos recuperan su comportamiento previo.

Si falla la creación del dispositivo virtual o los permisos, ejecutar `restore` o volver al snapshot de la VM.
