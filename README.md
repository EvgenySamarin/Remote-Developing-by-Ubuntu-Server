# Remote-Developing-by-Ubuntu-Server
Разбираемся как можно программировать с использованием удалённого сервера через интернет с любого устройства (при наличии экрана, подключения по ssh и консольного редактора)

# А собственно зачем?
![img boy](/res/boy.png)

Хороший вопрос, как насчет возможности писать код на любом устройстве? даже на смартфоне, планшете и д.р. Не бояться, что у тебя в дороге разрядится ноутбук, да и в целом это отличная возможность подтянуть свои знания по администрированию консольных серверов. [Вот отличный и наглядный пример использования мобилки](https://www.youtube.com/watch?v=2Dv61Gz3M4Q). __удобней ноутбука?__ очевидно нет, но ничто тебе не мешает использовать ноутбук в связке с удаленным сервером и кайфовать от осознания своего превосходства над простыми смертными )).

Итак, что же нам нужно для начала разработки? Давай разбираться по порядку.

# Шаг первый - Нам нужен сервер!
Можно конечно сразу арендовать VDS сервер - вот неплохой вариант [simple cloud](https://simplecloud.ru/) или, вот ещё один зарубежный (кстати он очень популярен среди remote разработчиков, в особенности front-end) [DigitalOcean](https://www.digitalocean.com/). 
На мой взгляд - прыгать с места в карьер не стоит - сперва поднимем виртуальную машину, прикинем что к чему, а уже потом набравшись опыта и убедившись, что нам это __действительно нужно__ займемся арендой.

> Какой сервер выбрать? - да в целом любой, на моем домашнем ПК установлен Ubuntu Desktop, поэтому я выберу сервер на Ubuntu.

Идем на домашнюю [страницу проекта](https://ubuntu.com/download/server/thank-you?country=RU&version=18.04.3&architecture=amd64#download) и скачиваем TLS сервер последней версии. Нестабильные сборки не рекомендую, могут возникнуть проблемы при установке.

Также нам потребуется виртуальная машина. Моё предпочтение - qemu-kvm. Её использует уже установленная на моём пк Android Studio, а зачем устанавливать дополнительное по? [гайд по установке qemu](https://help.ubuntu.ru/wiki/kvm)

Для более наглядной установки используем virt-manager. Его как правило устанавливают сразу при установке виртуальной машины.

Менеджер виртуальных машин использует директорию /var/lib/libvirt/images - забрасываем туда наш скачанный iso образ и создаем новую виртуальную машину в virt manager.
[инструкции по установке ubuntu server](https://losst.ru/ustanovka-ubuntu-server-18-04)

> для установки подберем такие параметры, какие мы планировали арендовать в облаке, а конкретней - самые простые. 

самый дешевый тариф simple cloud 150р/мес

- 512MB RAM
- 1 ядро CPU
- 5GB SSD диск
- 250GB трафик *

> во время установки сервера не устанавливаем никаких пакетов из предложенного списка.

Итак предположим у нас всё прошло гладко и мы установили наш консольный сервер, что дальше?

## Шаг второй - Настройка сервера для работы
Так как сервер у нас консольный, придется работать в консольном режиме. 0_о. Таковы жертвы удаленного программирования. 
Чтож нам придется много печатать, да еще и __без мышки!!!__ Кажется пора паниковать и сдаваться - это не про нас, ведь так? 

Нам необходима быстрая и удобная навигация по нашему будущему коду, а значит нам нужно хорошее средство для этого. Чтож боюсь у нас не так много выбора, а если быть честным его нет. Нам придется освоить Vim. Благо в сети интернет достаточно уроков по этому редактору. Могу посоветовать неплохой [канал на youtube](https://www.youtube.com/watch?v=zNnsNtBF80g&list=PLcjongJGYetkY4RFSVftH43F91vgzqB7U).

Пойди и пройди курсы по vim, а потом возвращайся и продолжим.

Параллельно с прохождением курса по vim необходимо установить JDK, ведь Java программисту нужна Java. [тутор по java install](https://help.ubuntu.ru/wiki/java)

> $ sudo apt-get install default-jdk

### Шаг третий - Наводим красоту в vim
Итак, ты свыкся с участью работы в консольном редакторе и уже уверенно используеш jklh для навигации, а вокруг только безграничный черный экран и белый текст. Не унывай, есть методы облегчить себе жизнь в консоли - давай делать красиво. 
Прежде всего vim поддерживает plugin`ы` и это супер.
Чтобы эта штука заработала, придется немного попечатать. Дабы не устанавливать каждый плагин вручную, нам нужен менеджер плагинов - [вот статья по установке](https://rtfm.co.ua/vim-prevrashhaem-redaktor-v-ide-plaginy-i-vot-eto-vot-vsyo/).

Если кратко:
> $ curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

В ~/.vimrc добавляем:
```vim 
call plug#begn('~/.vim/plugged')

call plug#end()
```
Теперь можно в 1 короткую строку устанавливать любой понравившийся плагин из github, помещая имя плагина между begin и end

#### Плагинчики:
[YouCompleteMe](https://github.com/ycm-core/YouCompleteMe#linux-64-bit) - автозавершение текста на основе введенных тобой данных инструкция по установке:
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
Plug 'scrooloose/nerdtree' {'on': 'NERDTreeToggle'} " поддержка дерева файлов проекта
Plug 'udalov/kotlin-vim' " поддержка подсветки синтаксиса kotlin
Plug 'ycm-core/YouCompleteMe' " автозавершение текста
Plug 'jiangmiao/auto-pairs' " автоматические парные скобки и кавычки

call plug#end()

let g:onedark_hide_endofbuffer=1 " отключаем бесящие символы ~ вначале каждой пустой строки
colorscheme onedark " включаем скачанную тему

syntax on " подсветка синтаксиса
set number " нумерация строк
set mouse=a " Поддержка мышки - фиг тебе а не мышь - эта строка не работает в консольном режиме
set expandtab "пробел вместо символа /t
set tabstop=2 " Табуляция в 2 пробела
set hlsearch "подсветка поиска
set incsearch "инкрементальный поиск

map <C-n> : NERDTreeToggle<CR> " завязываем сочетание клавиш ctrl+N на открытие окна дерева проекта
```
На этом пока всё - пошел изучать настройку сервера 
