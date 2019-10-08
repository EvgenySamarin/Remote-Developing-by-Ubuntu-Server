# Remote-Developing-by-Ubuntu-Server
Разбираемся как можно программировать с использованием удалённого сервера через интернет с любого устройства (при наличии экрана, подключения по ssh и консольного редактора)

# А собственно зачем?
![img boy](/res/boy.png)

Хороший вопрос, как насчет возможности писать код на любом устройстве? На смартфоне, планшете и д.р. Не бояться, что у тебя в дороге разрядится ноутбук, да и в целом это отличная возможность подтянуть свои знания по администрированию консольных серверов. [Вот отличный и наглядный пример использования мобилки](https://www.youtube.com/watch?v=2Dv61Gz3M4Q). __Удобней ноутбука?__ очевидно нет, но ничто тебе не мешает использовать ноутбук в связке с удаленным сервером и кайфовать от осознания своего превосходства над простыми смертными )).

Итак, что же нам нужно для начала разработки? Давай разбираться по порядку.

# Шаг первый - Нам нужен сервер!
Можно конечно сразу арендовать VDS сервер - вот неплохой вариант [simple cloud](https://simplecloud.ru/) или, вот ещё один зарубежный (кстати он очень популярен среди remote разработчиков, в особенности front-end) [DigitalOcean](https://www.digitalocean.com/). 
На мой взгляд - прыгать с места в карьер не стоит - сперва поднимем виртуальную машину, прикинем что к чему, а уже потом набравшись опыта и убедившись, что нам это __действительно нужно__ займемся арендой.

> Какой сервер выбрать? - да в целом любой, на моем домашнем ПК установлен Ubuntu Desktop, поэтому я выберу сервер на Ubuntu.

Идем на домашнюю [страницу проекта](https://ubuntu.com/download/server/thank-you?country=RU&version=18.04.3&architecture=amd64#download) и скачиваем TLS сервер последней версии. Нестабильные сборки не рекомендую, могут возникнуть проблемы при установке.

Также нам потребуется виртуальная машина. Моё предпочтение - qemu-kvm. Её использует уже установленная на моём пк Android Studio, а зачем устанавливать дополнительное по? [гайд по установке qemu](https://help.ubuntu.ru/wiki/kvm)

Для более наглядной установки используем virt-manager. Его как правило устанавливают сразу, после выбора виртуальной машины на unix.

Менеджер виртуальных машин использует директорию /var/lib/libvirt/images - забрасываем туда наш скачанный iso образ. Открываем virt-manager и создаем новую виртуальную машину.
[инструкции по установке ubuntu server](https://losst.ru/ustanovka-ubuntu-server-18-04)

> Для установки подберем такие параметры, какие мы планировали арендовать в облаке. Мой выбор - самые простые, потому что дёшево. 

Самый простой тариф от simple cloud - 150 р./мес.:

- 512MB RAM
- 1 ядро CPU
- 5GB SSD диск
- 250GB трафик *

> Во время установки сервера __не устанавливаем__ дополнительные пакеты из предложенного списка.

Итак, предположим у нас всё прошло гладко и мы установили наш консольный сервер. Что дальше?

## Шаг второй - Настройка сервера для работы
Так как сервер у нас консольный, придется работать в консольном режиме. 0_о. Таковы жертвы удаленного программирования. 
Чтож, нам придется много печатать, да еще и __без мышки!!!__ Кажется пора паниковать и сдаваться - это не про нас, ведь так? 

Нам необходима быстрая и удобная навигация по будущему коду. Боюсь у нас не такой большой выбор консольных редакторов (nano, vim, zsh). Предлагаю остановиться на Vim - среди прочих он самый популярный. Благо в сети достаточно уроков по этому редактору, и у тебя не должно возникнуть проблем с его освоением. Могу посоветовать неплохой [канал на youtube](https://www.youtube.com/watch?v=zNnsNtBF80g&list=PLcjongJGYetkY4RFSVftH43F91vgzqB7U).

Пройди пару уроков по vim, чтобы понять что это за зверь, и возвращайся.

### Сладкая передышка на заигрывание с сервером
Параллельно с прохождением курсов по vim, необходимо установить JDK. Java программисту нужна Java машина. [тутор по java install](https://help.ubuntu.ru/wiki/java)

> $ sudo apt-get install default-jdk

Чтобы пользоваться компилятором на Java, необходимо прописать переменные окружения. Для java/bin в __PATH__ и java в __JAVA_HOME__. [Подробно о переменных окружения в linux](https://losst.ru/peremennye-okruzheniya-v-linux)

В Unix, Java устанавливается в директорию usr/lib/jvm/ по умолчанию. Смотрим, что у нас находится по указанному пути:
> $ cd /usr/lib/jvm/; ls

В моём случае нашелся пакет __java-11-openjdk-amd64__, однако ubuntu создаёт alias на последнюю установленную версию - __default-java__ его и будем использовать.
Редактируем файл системных переменных:
> $ sudo vim /etc/profile

Добавляем в конец файла строки:

export JAVA_HOME=$JAVA_HOME:/usr/lib/jvm/default-java/bin/java

export PATH=/usr/lib/jvm/default-java/bin:$PATH

Сохраняем и закрываем. Теперь перечитаем файл настроек, чтобы их применить:
> $ source /etc/profile

Проверим корректность наших действий и выведем переменные в консоль:
> $ echo $JAVA_HOME; echo $PATH

Прекрасно, теперь мы можем писать консольные Java приложения. Для особо пытливых умов - [Установка переменных JAVA_HOME / PATH в Unix/Linux](http://linux-notes.org/ustanovka-peremenny-h-java_home-path-v-linux/).

## Шаг третий - Наводим красоту в vim
Итак, ты свыкся с участью работы в консольном редакторе и уже уверенно используеш jklh для навигации, а вокруг только безграничный черный экран и белый текст. Не унывай, есть способы _раскрасить_ твой консольный мир.

Прежде всего vim поддерживает plugin`ы` и это настоящая магия. Плагины позволяют превратить скучный консольный редактор в _почти_ полноценную IDE.
Чтобы не устанавливать каждый плагин вручную, нам нужен менеджер плагинов - [вот статья по установке](https://rtfm.co.ua/vim-prevrashhaem-redaktor-v-ide-plaginy-i-vot-eto-vot-vsyo/).

Если кратко:
> $ curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

В ~/.vimrc добавляем:
```vim 
call plug#begn('~/.vim/plugged')

call plug#end()
```
Теперь можно в 1 короткую строку устанавливать любой понравившийся плагин из репозитория github, помещая автора и имя плагина между begin и end в файле настроек vimrc

#### Плагинчики:
Все плагины рассматривать не буду - их каждый подбирает под свои предпочтения ([заходи и выбирай любой понравившийся](https://vimawesome.com/)), остановлюсь подробнее на YCM - его установка не совсем тривиальна.
[YouCompleteMe](https://github.com/ycm-core/YouCompleteMe#linux-64-bit) - автозавершение текста на основе введенных тобой данных. Также эта штука проверяет синтаксис до компиляции на наличие ошибок, и поддерживает автокомплит на уровне библиотек javadoc. инструкция по установке:
1. - Установи плагин через vim-plug 
2. - Выполни след ряд комманд:
> $ sudo apt install build-essential cmake python3-dev
> $ cd ~/.vim/bundle/YouCompleteMe
> $ python3 install.py --java-completer

### Файл настройки vim используемый мной.
На Ubuntu vimrc располагается в директории ~/.vimrc

```vim

" Пример настройки vimrc файла.
"
" Дата создания 2019.10.03
"
" for Unix and OS/2:  ~/.vimrc

call plug#begn('~/.vim/plugged')

Plug 'joshdick/onedark.vim' " классная цветовая тема для vim
Plug 'vim-airline/vim-airline' " поддержка строки статуса
Plug 'vim-airline/vim-airline-themes' " темизация строки статуса
Plug 'scrooloose/nerdtree' {'on': 'NERDTreeToggle'} " поддержка дерева файлов проекта
Plug 'udalov/kotlin-vim' " поддержка подсветки синтаксиса kotlin
Plug 'ycm-core/YouCompleteMe' " автозавершение текста
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
set mouse=a " Поддержка мышки - фиг тебе а не мышь - эта строка не работает в консольном режиме
set expandtab "пробел вместо символа /t
set tabstop=2 " Табуляция в 2 пробела
set hlsearch "подсветка поиска
set incsearch "инкрементальный поиск

map <C-n> : NERDTreeToggle<CR> " завязываем сочетание клавиш ctrl+N на открытие окна дерева проекта
```
## Шаг четвертый - предварительные итоги
Давай проверим работу Java в связке с нашим настроенным vim
Переходим в домашнюю директорию, содаем в ней каталог для нашей тестовой программы и создаем файл нашей тестовой программы:
> $ cd /home; mkdir test; cd /test; vim Test.java

Наберем простой тестовый код, обрати внимание на автокомплит - ай да мы, ай да молодцы)
```vim
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

Как видишь - всё работает. `Так, а что там с нашим сервером?` Сколько мы потратили ресурсов на настройку и сколько нам осталось на коддинг? 

Смотрим параметры сервера:

> $ df -h

Чтож, после установки jdk, плагинов для vim из 5 gb у нас осталось 420 мб. Достаточно много для чистого консольного коддинга на Java.

## Шаг пятый - установка Kotlin
Попробуем теперь набросить Kotlin и посмотрим [установка kotlin](https://www.cyberciti.biz/faq/how-to-install-kotlin-programming-language-on-ubuntudebian-linux/) вкратце:
> $ sudo apt install unzip

> $ sudo apt install zip

> $ wget -O sdk.install.sh "https://get.sdkman.io"

Можно посмотерть чего мы там скачали (для особо недоверчивых):
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

## Шаг шестой. Установка сборщика пакетов
Чтобы не заниматься ручной компиляцией, необходимо установить сборщик пакетов. Я выберу тот что использую для android studio на работе - gradle
