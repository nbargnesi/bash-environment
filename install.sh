#!/usr/bin/env bash
# Copyright © 2011 Nick Bargnesi <nick@den-4.com>.  All rights reserved.
#
# bash-environment is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# bash-environment is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with bash-environment.  If not, see <http://www.gnu.org/licenses/>.

if [ ! -d "env" ]; then
    echo "Run from top-level directory."
    exit 1
fi

# Backup before we install ourselves
NOW=$(date +%H.%M.%S-%m-%d-%y)
BACKUP_FILE=${USER}-${NOW}-env.tar.bz2
echo -en "Creating backup of current environment... "
tar Ppcaf ${BACKUP_FILE} \
    $HOME/.bash_aliases \
    $HOME/.bash_bindings \
    $HOME/.bash_colors \
    $HOME/.bash_exports \
    $HOME/.bash_functions \
    $HOME/.bash_profile \
    $HOME/.bash_theme_* \
    $HOME/.bashrc
echo "done"
echo "Old files backed up to... ${BACKUP_FILE}"

echo "Looking at current environment... "
for file in env/*; do
    BASE=$(basename ${file})
    if [ -f "$HOME/.${BASE}" ]; then
        DIFF=$(diff ${file} "$HOME/.${BASE}" > /dev/null)
        if [ $? -eq 1 ]; then
            echo -e "\t${file} is out of date, updating $HOME/.${BASE}"
            cp ${file} "$HOME/.${BASE}"
        fi
    else
        echo -e "\t${file} is missing, installing as $HOME/.${BASE}"
        cp ${file} "$HOME/.${BASE}"
    fi
done
echo "Environment is up to date."
