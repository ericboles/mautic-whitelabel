#!/usr/bin/env bash
set -euo pipefail

MAUTIC_VERSION="5.2.8"
PROJECT_ROOT="/var/www/html"
APP_DIR="${PROJECT_ROOT}/mautic"
PLUGIN_DIR="${PROJECT_ROOT}"
LOCAL_CONFIG_DIST="${PLUGIN_DIR}/.ddev/local.config.php.dist"
LOCAL_CONFIG_TARGET="${APP_DIR}/config/local.php"

cd "${PROJECT_ROOT}"

rm -rf "${APP_DIR}"

echo "> Creating Mautic $MAUTIC_VERSION project in ./mautic ..."
composer create-project "mautic/recommended-project:$MAUTIC_VERSION" mautic --no-interaction

cd "${APP_DIR}"

echo "> Configuring path repository to local plugin ..."
composer config repositories.matbcvo-whitelabel \
'{"type":"path","url":"../","options":{"symlink":true}}'

echo "> Allowing Composer plugins ..."
composer config allow-plugins.matbcvo/mautic-whitelabel true
composer config allow-plugins.composer/installers true
composer config allow-plugins.mautic/composer-plugin true

echo "> Requiring matbcvo/mautic-whitelabel as *@dev ..."
composer require matbcvo/mautic-whitelabel:*@dev --no-interaction || true

echo "> Writing config/local.php from .ddev/local.config.php.dist ..."
mkdir -p "$(dirname "${LOCAL_CONFIG_TARGET}")"
cp -f "${LOCAL_CONFIG_DIST}" "${LOCAL_CONFIG_TARGET}"

php bin/console mautic:install "https://${DDEV_HOSTNAME}" --force

echo "Mautic is installed, located in ./mautic, served from ./mautic/docroot."
