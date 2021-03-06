# Remote-Developing-by-Ubuntu-Server
Разбираемся, как можно программировать, с использованием удалённого сервера, через интернет с любого устройства (при наличии экрана, подключения по ssh и консольного редактора)
test push--

# А собственно зачем?
![img boy](/res/boy.png)

Хороший вопрос, как насчет возможности писать код на любом устройстве? На смартфоне, планшете и д.р. Не бояться, что у тебя в дороге разрядится ноутбук, да и в целом это отличная возможность подтянуть свои знания по администрированию консольных серверов. [Вот отличный и наглядный пример использования мобилки](https://www.youtube.com/watch?v=2Dv61Gz3M4Q). __Удобней ноутбука?__ очевидно нет, но ничто тебе не мешает использовать ноутбук в связке с удаленным сервером и кайфовать от осознания своего превосходства над простыми смертными )).

Итак, что же нам нужно для начала разработки? Давай разбираться по порядку.

## Шаг первый — Нам нужен сервер!
Можно конечно сразу арендовать VDS сервер — вот неплохой вариант [simple cloud](https://simplecloud.ru/) или, вот ещё один зарубежный (кстати он очень популярен среди remote разработчиков, в особенности front-end) [DigitalOcean](https://www.digitalocean.com/).
На мой взгляд - прыгать с места в карьер не стоит - сначала поднимем виртуальную машину, прикинем что к чему, а уже потом набравшись опыта и убедившись, что нам это __действительно нужно__ займемся арендой.

> Какой сервер выбрать? - да в целом любой, на моем домашнем ПК установлен Ubuntu Desktop, поэтому я выберу сервер на Ubuntu.

Идем на домашнюю [страницу проекта](https://ubuntu.com/download/server/thank-you?country=RU&version=18.04.3&architecture=amd64#download) и скачиваем TLS сервер последней версии. Нестабильные сборки не рекомендую, могут возникнуть проблемы при установке.

Также нам потребуется виртуальная машина. Моё предпочтение - qemu-kvm. Её использует уже установленная на моём пк Android Studio, а зачем устанавливать дополнительное по? [гайд по установке qemu](https://help.ubuntu.ru/wiki/kvm)

Для более наглядной установки используем virt-manager. Его, как правило, устанавливают сразу, после выбора виртуальной машины на unix.

Менеджер виртуальных машин использует директорию `/var/lib/libvirt/images` - забрасываем туда наш скачанный iso образ. Открываем virt-manager и создаем новую виртуальную машину.
[инструкции по установке ubuntu server](https://losst.ru/ustanovka-ubuntu-server-18-04)

> Для установки подберем такие параметры, какие мы планировали арендовать в облаке. Мой выбор - самые простые, потому что дёшево. __!!!, чтобы сэкономить тебе время, оговорим: если планируется использовать VDS для андроид разработки, самый дешевый тариф не подойдет - см. шаг восьмой__

Самый простой тариф от simple cloud - 150 р./мес.:

- 512MB RAM
- 1 ядро CPU
- 5GB SSD диск
- 250GB трафик *

> Во время установки сервера __не устанавливаем__ дополнительные пакеты из предложенного списка.

Итак, предположим у нас всё прошло гладко и мы установили наш консольный сервер. Что дальше?

## Шаг второй - Настройка сервера для работы
Сразу оговорим, что все настройки будем делать так, как будто у нас уже существует собственный VDS.
Первое с чего стоит начать настройку сервера, обновление всех существующих пакетов:
> $ apt-get update && apt-get upgrade

Теперь нам нужен пользователь с правами `su`, работать под `root` не рекомендую (если накосячишь, то поправить дело не получится). При создании пользователя, пароль выбирай посложней, чтобы привыкать к работе через internet:
> $ adduser username

Добавляем пользователя в группу суперпользователей:
> $ gpasswd -a username sudo

Так как сервер у нас консольный, придется работать в консольном режиме. 0_о. Таковы жертвы удаленного программирования.
Чтож, нам придется много печатать, да еще и __без мышки!!!__, а значит нам необходима быстрая и удобная навигация по будущему коду. Боюсь у нас не такой большой выбор консольных редакторов (nano, vim, Emacs и еще [парочка других](https://geekmaze.ru/2016/07/13/konsolnye-tekstovye-redaktory-linux/)). Предлагаю остановиться на Vim - среди прочих он самый популярный. Благо в сети достаточно уроков по этому редактору, и у тебя не должно возникнуть проблем с его освоением. Могу посоветовать неплохой [канал на youtube](https://www.youtube.com/watch?v=zNnsNtBF80g&list=PLcjongJGYetkY4RFSVftH43F91vgzqB7U).

Пройди пару уроков по vim, чтобы понять что это за зверь, и возвращайся.

Теперь немного безопасности: следует как можно сильнее запутать хацкеров и поправить настройки будущего подключения, отредактируем файл `sshd_conf`
> $ vim /etc/ssh/sshd_config

В файле запрещаем подключаться к серверу через root пользователя - `PermitRootLogin no`, меняем стандартный порт подключения на любой из диапазона 49152-65535, такой диапазон обеспечит минимальную возможность конфликта с unix службами `Port 50132`. После редактирования соответствующих строк перезапускаем службу ssh
> $ service ssh restart

Также следует установить __git__, практически каждый разработчик плагинов или open source команда использует VCS Git, в частности GitHub для распространения своих работ.
> $ sudo apt install git

Ну и в довесок, устанавливаем архиватор и раз-архиватор. Они нам пригодятся в будущем, для установки модулей.
> $ sudo apt install unzip

> $ sudo apt install zip

Теперь можно временно отключиться от сервера. Завершение сессии можно сделать через команду `exit`. 

## Шаг третий - настройка клиента
На моём домашнем ПК установлен Ubuntu 19.04, так что всю настройку далее буду описывать для UNIX. Впрочем, это по большей части справедливо и для систем отличных от Ubuntu, а для Windows можно, к примеру, воспользоваться WSL.

Подключиться к VDS серверу после всех манипуляций можно при помощи любого bash терминала следующей командой: `ssh -p 50132 user@77.11.22.33`, где 50132 - порт, а 77.11.22.33 - ip адрес сервера. Сервер запросит пароль указанного `user`а и пропустит.

Подключение по паролю это конечно хорошо, но что делать, если у тебя хороший пароль, а ты такой весь из себя ленивая жопа.

![img](res/fat-cat.jpg)

Весьма запарно вводить длинный страшный криптостокий пароль свякий раз, как ты собрался поработать. К счастью [ssh позволяет более удобно авторизоваться на удаленном сервере](https://habr.com/ru/post/122445/).
Для этого используются ssh ключи, нам нужно создать ключ, защитить его пин-кодом на всякий случай. __!!! ПИН КОД НЕ ЗАБЫВАЙ И НЕ ТЕРЯЙ, ЕГО НЕЛЬЗЯ ВОССТАНОВИТЬ__
> $ ssh-keygen

Далее копируем ключ на удаленный сервер:
> $ ssh-copy-id -p 443 user@server

Чудесненько, теперь можно авторизоваться на сервере без ввода пароля. Стоп, мы можем пойти дальше, сократим подключение к vds до команды `ssh vds`. Это возможно сделать [используя alias`ы`](https://www.cyberciti.biz/faq/create-ssh-config-file-on-linux-unix/).
Создаем файл конфигурации ssh
> $ vim ~/.ssh/config

добавляем туда след конструкцию:
```ssh
## Вместо vds можно использовать любое слово
Host vds
    HostName <тут ip твоего сервера>
    Port <указанный тобой порт>
    User <созданный тобой пользователь на сервере>
    PasswordAuthentication no
    IdentityFile ~/.ssh/id_rsa
```
Теперь подключиться к серверу можно командой
> $ ssh vds

Ну разве не чудо?
На этом настройка клиента закончена, снова подключаемся к серверу. 

## Шаг четвертый - Установка Java Virtual Machine
Java программисту нужна Java машина. [тутор по java install](https://help.ubuntu.ru/wiki/java)

> $ sudo apt-get install default-jdk

Чтобы пользоваться компилятором на Java, необходимо прописать переменные окружения. Для java/bin в __PATH__ и java в __JAVA_HOME__. [Подробно о переменных окружения в linux](https://losst.ru/peremennye-okruzheniya-v-linux)

В Unix, Java устанавливается в директорию `usr/lib/jvm/` по умолчанию. Смотрим, что у нас находится по указанному пути:
> $ cd /usr/lib/jvm/; ls

В моём случае нашелся пакет __java-11-openjdk-amd64__, однако ubuntu создаёт `alias` на последнюю установленную версию - __default-java__ его и будем использовать.
Редактируем файл системных переменных:
> $ sudo vim /etc/profile

Добавляем в конец файла строки:

```sh
export JAVA_HOME=$JAVA_HOME:/usr/lib/jvm/default-java/
export PATH=/usr/lib/jvm/default-java/bin:$PATH
```

Сохраняем и закрываем. Теперь перечитаем файл настроек, чтобы их применить:
> $ source /etc/profile

Проверим корректность наших действий и выведем переменные в консоль:
> $ echo $JAVA_HOME; echo $PATH

Прекрасно, теперь мы можем писать консольные Java приложения. Для особо пытливых умов - [Установка переменных JAVA_HOME / PATH в Unix/Linux](http://linux-notes.org/ustanovka-peremenny-h-java_home-path-v-linux/).

### Давай сделаем терминал поживее
Раскрашиваем имя пользователя:
> $ vim ~/.bashrc

Найди строку `#force_color_prompt=yes` и сними с неё комментарий, затем сохрани, выйди и перечитай файл, чтобы применить настройки:
> $ source ~/.bashrc

## Шаг пятый - Наводим красоту в vim
Итак, ты свыкся с участью работы в консольном редакторе и уже уверенно используешь jklh для навигации, а вокруг только безграничный черный экран и белый текст. Не унывай, есть способы _раскрасить_ твой консольный мир.

Прежде всего vim поддерживает plugin`ы` и это настоящая магия. Плагины позволяют превратить скучный консольный редактор в _почти_ полноценную IDE.
Чтобы не устанавливать каждый плагин вручную, нам нужен менеджер плагинов - [вот статья по установке](https://rtfm.co.ua/vim-prevrashhaem-redaktor-v-ide-plaginy-i-vot-eto-vot-vsyo/).

Если кратко:
> $ curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

В ~/.vimrc добавляем:
```vim
call plug#begin('~/.vim/plugged')

call plug#end()
```
Теперь можно в 1 короткую строку устанавливать любой понравившийся плагин из репозитория github, помещая автора и имя плагина между begin и end в файле настроек vimrc

#### Плагинчики:
Все плагины рассматривать не буду - их каждый подбирает под свои предпочтения ([заходи и выбирай любой понравившийся](https://vimawesome.com/)), остановлюсь подробнее на YCM - его установка не совсем тривиальна.
[YouCompleteMe](https://github.com/ycm-core/YouCompleteMe#linux-64-bit) - авто завершение текста на основе введенных тобой данных. Также эта штука проверяет синтаксис до компиляции на наличие ошибок, и поддерживает автокомплит на уровне библиотек.
Инструкция по установке:
1. - Установи плагин через vim-plug
2. - Выполни след ряд команд:
> $ sudo apt install build-essential cmake python3-dev

В строке ниже plugged может не сработать, это зависит от места куда копируется репозиторий плагина, найти его можно командой `find ~/ -name "YouCompleteMe" | grep -E "YouCompleteMe"`, как найдешь переходи, в эту директорию
> $ cd ~/.vim/plugged/YouCompleteMe

> $ python3 install.py --java-completer

### Файл настройки vim используемый мной.
На Ubuntu vimrc располагается в директории ~/.vimrc

```vim

" Пример настройки vimrc файла.
"
" Дата создания 2019.10.03
"
" for Unix and OS/2: ~/.vimrc

call plug#begin('~/.vim/plugged')

Plug 'joshdick/onedark.vim' " классная цветовая тема для vim
Plug 'vim-airline/vim-airline' " поддержка строки статуса
Plug 'vim-airline/vim-airline-themes' " темизация строки статуса
Plug 'scrooloose/nerdtree' {'on': 'NERDTreeToggle'} " поддержка дерева файлов проекта
Plug 'udalov/kotlin-vim' " поддержка подсветки синтаксиса kotlin
Plug 'ycm-core/YouCompleteMe' " авто завершение текста
Plug 'jiangmiao/auto-pairs' " автоматические парные скобки и кавычки
Plug 'tpope/vim-fugitive' " включаем нативную поддержку git
Plug 'airblade/vim-gitgutter' " поддержка столбца иконок изменения файла для git
Plug 'sheerun/vim-polyglot' " поддержка синтаксиса огромного кол-ва языков

call plug#end()

let g:airline_theme='base16_spacemacs' " если сервер не поддерживает 24 бита, чтоб не шакалило строку статуса
let g:onedark_termcolors=16 " если сервер не поддерживает 24 бита, чтоб не шакалило тему onedark
let g:onedark_hide_endofbuffer=1 " отключаем бесящие символы ~ вначале каждой пустой строки
colorscheme onedark " включаем скаченную тему

syntax on " подсветка синтаксиса
set number " нумерация строк
set mouse=a " Поддержка мышки - фиг тебе, а не мышь - эта строка не работает в консольном режиме
set expandtab "пробел вместо символа /t
set tabstop=2 " Табуляция в 2 пробела
set hlsearch "подсветка поиска
set incsearch "инкрементальный поиск

map <C-n> : NERDTreeToggle<CR> " завязываем сочетание клавиш ctrl+N на открытие окна дерева проекта
```
## Шаг шестой - предварительные итоги
Давай проверим работу Java в связке с нашим настроенным vim
Переходим в домашнюю директорию, создаем в ней каталог для нашей тестовой программы и создаем файл нашей тестовой программы:
> $ cd /home; mkdir test; cd /test; vim Test.java

Наберем простой тестовый код, обрати внимание на автокомплит - ай да мы, ай да молодцы)
```java
class Test {
    public static void main(String[] args) {
        System.out.println("Hello World!");
    }
}
```
теперь скомпилируем программу
> $ javac Test.java

И запустим:
> $ java Test

Как видишь - всё работает. __Так, а что там с нашим сервером?__ Сколько мы потратили ресурсов на настройку и сколько нам осталось на коддинг?

Смотрим параметры сервера:

> $ df -h

Что ж, после установки jdk, плагинов для vim из 5 gb у нас осталось 420 мб. Достаточно много для чистого консольного коддинга на Java.

## Шаг седьмой - установка Kotlin
Попробуем теперь набросить Kotlin и посмотрим [установка kotlin](https://www.cyberciti.biz/faq/how-to-install-kotlin-programming-language-on-ubuntudebian-linux/) вкратце:

Качаем устанавливатель kotlin
> $ wget -O sdk.install.sh "https://get.sdkman.io"

Можно посмотреть, чего мы там скачали (для особо недоверчивых):
> $ vim sdk.install.sh

> $ bash sdk.install.sh

> $ source ~/.sdkman/bin/sdkman-init.sh

> $ sdk install kotlin

Готово, теперь мы можем писать программы и на котлин (правда без автокомплита, для этого нужно будет поискать необходимый плагин для VIM YCM [например синтаксис можно поддержать вот этим](https://vimawesome.com/plugin/kotlin-vim).
Компилирование котлин файлов:
> $ kotlinc <имя файла>.kt -include-runtime -d <имя файла>.jar

Запуск скомпилированной программы:
> $ java -jar <имя файла>.jar

После установки kotlin свободного места осталось: __315mb.__

В целом этого уже достаточно для рефакторинга существующих проектов. Тянем репозиторий - редактируем проект.

## Шаг восьмой. Если ты android разработчик
Для андроид разработки нам необходимо затянуть на сервер android sdk [отличный sh скрипт по установке](https://gist.github.com/zhy0/66d4c5eb3bcfca54be2a0018c3058931) - и тут у нас возникают сложности. Свободного места не хватает даже на зажатый sdk tools. Очевидно самый дешевый тариф VDS нам не подходит, следующий по стоимости тариф:
SimpleCloud 250 р./мес.:

- 1GB RAM
- 1 ядро CPU
- 20GB SSD диск
- Безлимитный трафик

DigitalOcean 5$(350р.)/мес.:
- 1 GB RAM
- 1 vCPU
- 1 TB
- 25 GB

Ок, если мы хотим продолжить - нам придется пересоздавать виртуальную машину под новые параметры, иначе, если ты обратил внимание на моё предупреждение вначале - у тебя уже машинка с 20 Gb.

### Установка sdk:
Скачиваем какой-нибудь sdk tools пакет с сайта [developer android](https://developer.android.com/studio/index.html#downloads) в директорию `$HOME`
> $ cd ~; wget https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz

Распаковываем архив (_после распаковки скачанный архив можно удалить_):
> $ tar xf android-sdk*-linux.tgz

Переходим в распакованный архив в каталог tools и запускаем обновление компонентов, с параллельной установкой актуального sdk:
> $ cd android-sdk-linux/tools; ./android update sdk --all --no-ui --filter $(seq -s, 29)

Если тебе нужна какая-то спец версия sdk можно узнать какие из версий доступны след образом (в директории tools):
> $ ./android list sdk --all

Установить определённые пакеты можно с помощью команды:
> $ ./android update sdk --no-ui --all --filter 1,2,3,<...>,N

Где N - номер пакета

Теперь прописываем переменные окружения для `ANDROID_HOME, PATH`
> $ echo 'export ANDROID_HOME=$HOME/android-sdk-linux' >> ~/.bashrc

> $ echo 'export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools' >> ~/.bashrc

Перечитываем настройки переенных:
> $ source ~/.bashrc

Добавляем в систему возможность исполнять i386 файлы (актуально для x64 архитектур)
> $ sudo dpkg --add-architecture i386; sudo apt-get update; sudo apt-get install -y libc6:i386 libstdc++6:i386 zlib1g:i386

### Ускорение компиляции и сборки проектов
На нашем сервере всего 1gb  ОЗУ, а значит нам потребуется swap:
> $ sudo fallocate -l 2G /swapfile; sudo chmod 600 /swapfile; sudo mkswap /swapfile; sudo swapon /swapfile

Не секрет, что андроид приложения используют системы сборки проектов, самая популярная Gradle, запуск gradle тоже можно ускорить, создав фоновый процесс build системы:
> $ mkdir ~/.gradle; echo 'org.gradle.daemon=true' >> ~/.gradle/gradle.properties

### Что по ресурсам?
![img boy](/res/simple-man.jpg)

Я человек простой, есть что скачать - качаю, поэтому залил весь пакет sdk (все версии) на свой сервер, это происходит если запустить `./android update sdk --no-ui` без фильтра.
После всех манипуляций размер виртуальной машины подрос до 13 gb + 2 gb на разработку проекта. Это оправдывает выбор в пользу 20gb. 

В целом места ещё достаточно.

## Шаг девятый - система сборки
В процессе разработки под android всегда хочется использовать готовые библиотеки, созданные умными дядьками (ты же не будешь писать свой material design, JUnit и другие базовые вещи). Даже переиспользовать свой собственный код весьма запарно, тебе нужно его или упаковывать в jar или копипастить в каждый проект. 
Итак, чтобы подключать сторонние библиотеки приходится писать много кода, да ещё и при каждой компиляции своего приложения - ужас.

Чтобы автоматизировать процесс построения выходного apk файла были придуманы системы сборки ([эта статья должна тебя убедить что build-tools это круто](https://javarush.ru/groups/posts/2126-kratkoe-znakomstvo-s-gradle)). Систем достаточно много в 2к19, я использую gradle, давай его установим, тем более для этого у нас уже всё есть.

На пятом шаге мы установили [sdkman](https://sdkman.io/), он нам сейчас и пригодится:
> $ sdk install gradle

Вот это действительно было просто!

# Ты прошел все девять шагов и полностью готов к удалённой разработке

![img](res/dante.jpg)

Как это использовать, напишу позже, в другой статье. 
В дополнение прикладываю sh скрипты для более быстрой настройки сервера под разные сценарии и собственно настройки клиента. Если хочешь установить всё как описано выше просто выполни все скрипты последовательно.

- [sh скрипт для быстрой первоначальной настройки сервера под Java](server-config.sh)
- [sh скрипт для быстрой настройки клиента](client-config.sh)
- [sh скрипт для быстрой настройки vim](vim-config.sh)
- [sh скрипт для быстрой установки kotlin](kotlin-android-config.sh)
- [sh скрипт для быстрой настройки gradle](vim-config.sh)

