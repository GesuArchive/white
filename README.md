![Aleph](https://github.com/frosty-dev/white/assets/10297716/bbe4608c-d65d-46ef-9d02-99a60f375db3)

### Это основной репозиторий Aleph (old White Dream) по игре [Space Station 13](https://station13.ru/). 

## Быстрый старт
1. Требования
	* Для сборки проекта необходим [BYOND](https://www.byond.com/download/).
2. Сборка и запуск
	* Отклонировать/скачать данный репозиторий и запустить `BUILD.cmd`.
	* Скопировать содержимое из папки `config` в рабочую папку `cfg`.
	* Для поднятия локального сервера, запустите `server.cmd` из директории `bin`.

* Пользователям Ubuntu/Debian:
	```bash
	git clone https://github.com/frosty-dev/white && cd white

	# Сборка библиотеки rust-g и auxmos
	sudo dpkg --add-architecture i386
	sudo apt update || true
	sudo apt install -o libssl1.1:i386
	bash tools/ci/install_rust_g.sh

	# Установка BYOND и запуск сервера
	bash tools/ci/install_byond.sh
	source $HOME/BYOND/byond/bin/byondsetup
	tools/build/build
	bash tools/ci/run_server.sh
	```

## Среда разработки
[<img src="https://i.imgur.com/FMf8JBF.png" alt="Старт" width="150" align="left">](https://hackmd.io/@fdev/SJDYI8iR8)
**Работаешь с кодом впервые?**<br>Попробуй этот гайд, он обязательно тебя научит чему-нибудь, если будет в настроении!

## Наше сообщество
[<img src="https://i.imgur.com/NhGX9XW.png" alt="Funclub" width="150" align="left">](https://funclub.pro)
**Крупнейшее игровое сообщество по вселенной SCP:SL.**<br>А также других игр, включая **Space Station 13**.

[<img src="https://i.imgur.com/o40zWyV.png" alt="Station13.Ru" width="150" align="left">](https://station13.ru)
**Это один маленький шаг для билда, но гигантский скачок для всего сообщества.**<br>Основной сайт пост-анимуса.

[<img src="https://i.imgur.com/7iYrb2J.png" alt="Wiki" width="150" align="left">](https://wiki.station13.ru)
**Ваш путеводитель по вселенной Space Station 13.**<br>Практически всегда актуальна.
<!--
[<img src="https://i.imgur.com/dUdgAL5.png" alt="Forum" width="150" align="left">](https://forum.station13.ru)
**Наш форум. Скопление живых трупов и заблудших душ.**<br> Лучшее место для свободных дискуссий на любые темы.
-->
[<img src="https://i.imgur.com/lOHdByt.png" alt="Discord" width="150" align="left">](https://discord.station13.ru/)
**Наш Discord-сервер.**<br>Общение космонавтов. Основная конференция посвящённая White Dream SS13.

[<img src="https://i.imgur.com/eQF6BOl.png" alt="CR34T1V3" width="150" align="left">](https://discord.gg/fRsn7RxdQp)
**Альтернативный кодербас для русскоговорящих господ.**<br>Ничего личного, только копипаста. Место, где можно обсудить код и не только.

## Полезное
[<img src="https://i.imgur.com/ZOxkRtD.png" alt="Upstream" width="150" align="left">](https://github.com/tgstation/tgstation)
**Наш Upstream. Ничего особенного.**<br>Основная часть обновлений берётся отсюда.

[<img src="https://i.imgur.com/RwAIgu6.png" alt="Баги" width="150" align="left">](https://hackmd.io/IiFh5OR4S-q9JNzos8gWaw)
**Баги и что с ними делать.**<br>Гарантированное решение, когда фича перерастает в проблему.

[<img src="https://i.imgur.com/estrNVg.png" alt="Локализация" width="150" align="left">](https://hackmd.io/8mn18B1yTY6ki0Xy-JifCw)
**То, зачем мы здесь.**<br>Быстрое входное обучение для тех, кто желает привнести русский дух в игру.

[<img src="https://i.imgur.com/ZKyWpgK.png" alt="Иконки" width="150" align="left">](https://hackmd.io/vdsXbe-hSgyLtAzddg8yyQ)
**Как работать с этим форматом во внешних редакторах?**<br>В этом руководстве описан краткий гайд по работе с иконками бьёнда.

[<img src="https://i.imgur.com/uCDQuc4.png" alt="Редактор карт" width="150" align="left">](https://github.com/SpaiR/StrongDMM/releases)
**Наш основной инструмент для работы с картами.**<br>Экономит кучу времени, заменяя встроенный редактор практически полностью.


## Лицензия

Весь код после [коммита 333c566b88108de218d882840e61928a9b759d8f на 2014/31/12 в 4:38 PM PST](https://github.com/frosty-dev/white-dream-main/commit/333c566b88108de218d882840e61928a9b759d8f) лицензирован под [GNU AGPL v3](https://www.gnu.org/licenses/agpl-3.0.html).

Весь код до [коммита 333c566b88108de218d882840e61928a9b759d8f на 2014/31/12 в 4:38 PM PST](https://github.com/frosty-dev/white-dream-main/commit/333c566b88108de218d882840e61928a9b759d8f) лицензирован под [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
(Включая папку tools, но только если их readme не сообщает обратное)

Смотрите LICENSE и GPLv3.txt за подробностями.

TGS DMAPI API лицензирован как подпроект под MIT лицензией.

Посмотрите в самый низ [code/__DEFINES/tgs.dm](./code/__DEFINES/tgs.dm) и [code/modules/tgs/LICENSE](./code/modules/tgs/LICENSE) для MIT лицензии.

Все ассеты включая иконки и звуки лицензированы под [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/), если это не обозначено где-то ещё.

Опубликованный русскоязычный текст в коде находится под лицензией [Creative Commons 4.0 BY-NC-SA license](https://creativecommons.org/licenses/by-nc-sa/4.0/), если это не обозначено где-то ещё. Это подразумевает под собой то, что использование нашего перевода где-либо ещё требует наличие данной авторской лицензии (включая всех авторов, которые когда-либо вносили правки) и отметки о том, что было изменено.

