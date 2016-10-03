#Использовать asserts
#Использовать logos

Перем Лог;

Перем ВыводКоманды;
Перем ИмяФайлаИнформации;
Перем РабочийКаталог;
Перем ПутьКГит;

Перем ЭтоWindows;

/////////////////////////////////////////////////////////////////////////
// Программный интерфейс

/////////////////////////////////////////////////////////////////////////
// Процедуры-обертки над git

Процедура Инициализировать() Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("init");
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

Функция Статус() Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("status");
    
    ВыполнитьКоманду(ПараметрыЗапуска);

    Возврат ПолучитьВыводКоманды();

КонецФункции

Процедура ДобавитьФайлВИндекс(Знач ПутьКДобавляемомуФайлу) Экспорт

    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("add");
    ПараметрыЗапуска.Добавить(ПутьКДобавляемомуФайлу);
    
    ВыполнитьКоманду(ПараметрыЗапуска);

КонецПроцедуры

Процедура Закоммитить(Знач ТекстСообщения, Знач ПроиндексироватьОтслеживаемыеФайлы = Ложь) Экспорт

    ПараметрыЗапуска = Новый Массив;
	ПараметрыЗапуска.Добавить("commit");

	Если ПроиндексироватьОтслеживаемыеФайлы Тогда
        ПараметрыЗапуска.Добавить("-a");
    КонецЕсли;

    ПараметрыЗапуска.Добавить("-m");
    ПараметрыЗапуска.Добавить(ТекстСообщения);
    
    ВыполнитьКоманду(ПараметрыЗапуска);

КонецПроцедуры

Процедура Получить(Знач ИмяРепозитория = "", Знач ИмяВетки = "") Экспорт

    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("pull");

    Если ЗначениеЗаполнено(ИмяРепозитория) Тогда
        ПараметрыЗапуска.Добавить(ИмяРепозитория);
    КонецЕсли;

    Если ЗначениеЗаполнено(ИмяВетки) Тогда
        ПараметрыЗапуска.Добавить(ИмяВетки);
    КонецЕсли;
    
    ВыполнитьКоманду(ПараметрыЗапуска);

КонецПроцедуры

Процедура Отправить(Знач ИмяРепозитория = "", Знач ИмяВетки = "") Экспорт

    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("push");

    Если ЗначениеЗаполнено(ИмяРепозитория) Тогда
        ПараметрыЗапуска.Добавить(ИмяРепозитория);
    КонецЕсли;

    Если ЗначениеЗаполнено(ИмяВетки) Тогда
        ПараметрыЗапуска.Добавить(ИмяВетки);
    КонецЕсли;
    
    ВыполнитьКоманду(ПараметрыЗапуска);

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Параметры) Экспорт
    
    //NOTICE: https://github.com/oscript-library/v8runner 
    //Apache 2.0 
    
    ПроверитьВозможностьВыполненияКоманды();
    
    Файл = Новый Файл(ПолучитьФайлИнформации());
    Если Файл.Существует() Тогда
        Попытка
            Лог.Отладка("Удаляю файл информации 1С");
            УдалитьФайлы(Файл.ПолноеИмя);
        Исключение
            Лог.Предупреждение("Не удалось удалить файл информации: " + ОписаниеОшибки());
        КонецПопытки;
    КонецЕсли;
    
    КодВозврата = ЗапуститьИПодождать(Параметры);
    УстановитьВывод(ПрочитатьФайлИнформации());
    Если КодВозврата <> 0 Тогда
        Лог.Ошибка("Получен ненулевой код возврата "+КодВозврата+". Выполнение скрипта остановлено!");
        ВызватьИсключение ПолучитьВыводКоманды();
    Иначе
        Лог.Отладка("Код возврата равен 0");
    КонецЕсли;
    
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////
// Работа со свойствами класса

Функция ПолучитьРабочийКаталог() Экспорт
    Возврат РабочийКаталог;
КонецФункции

Процедура УстановитьРабочийКаталог(Знач ПутьРабочийКаталог) Экспорт
    
    Файл_РабочийКаталог = Новый Файл(ПутьРабочийКаталог);
    Ожидаем.Что(Файл_РабочийКаталог.Существует(), СтрШаблон("Рабочий каталог <%1> не существует.", ПутьРабочийКаталог)).ЭтоИстина();
    
    РабочийКаталог = Файл_РабочийКаталог.ПолноеИмя;
    
КонецПроцедуры

Функция ПолучитьПутьКГит() Экспорт
    Возврат ПутьКГит;
КонецФункции

Процедура УстановитьПутьКГит(Знач Путь) Экспорт
    ПутьКГит = Путь;
КонецПроцедуры

Функция ПолучитьВыводКоманды() Экспорт
    Возврат ВыводКоманды;
КонецФункции

Процедура УстановитьВывод(Знач Сообщение)
    ВыводКоманды = Сообщение;
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////
// Работа со служебными свойствами класса

Функция ПрочитатьФайлИнформации()
    
    //NOTICE: https://github.com/oscript-library/v8runner 
    //Apache 2.0 
    
    Текст = "";
    
    Файл = Новый Файл(ПолучитьФайлИнформации());
    Если Файл.Существует() Тогда
        Чтение = Новый ЧтениеТекста(Файл.ПолноеИмя);
        Текст = Чтение.Прочитать();
        Чтение.Закрыть();
    Иначе
        Текст = "Информации об ошибке нет";
    КонецЕсли;
    
    Лог.Отладка("файл информации:
    |" + Текст);
    Возврат Текст;
    
КонецФункции

Функция ПолучитьФайлИнформации()
    
    //NOTICE: https://github.com/oscript-library/v8runner 
    //Apache 2.0 
    
    Если ИмяФайлаИнформации = Неопределено Тогда
        выделенныйВременныйФайл = ПолучитьИмяВременногоФайла("txt");
        указательНаВременныйФайл = Новый Файл(выделенныйВременныйФайл);
        ИмяФайлаИнформации = указательНаВременныйФайл.Имя;
        указательНаВременныйФайл = "";
    КонецЕсли;
    
    Возврат ОбъединитьПути(ПолучитьРабочийКаталог(), ИмяФайлаИнформации);

КонецФункции

//////////////////////////////////////////////////////////////////////////
// Служебные процедуры и функции

Процедура ПроверитьВозможностьВыполненияКоманды()
    
    Ожидаем.Что(ПолучитьРабочийКаталог(), "Рабочий каталог не установлен.").Заполнено();
    
    Лог.Отладка("РабочийКаталог: " + ПолучитьРабочийКаталог());
    
КонецПроцедуры

Функция ЗапуститьИПодождать(Знач Параметры)
    
    //NOTICE: https://github.com/oscript-library/v8runner 
    //Apache 2.0 
    
    СтрокаЗапуска = "";
    СтрокаДляЛога = "";
    Для Каждого Параметр Из Параметры Цикл
        
        СтрокаЗапуска = СтрокаЗапуска + " " + Параметр;
        
        Если Лев(Параметр,2) <> "/P" и Лев(Параметр,25) <> "/ConfigurationRepositoryP" Тогда
            СтрокаДляЛога = СтрокаДляЛога + " " + Параметр;
        КонецЕсли;
        
    КонецЦикла;
    
    КодВозврата = 0;
    
    Приложение = ОбернутьВКавычки(ПолучитьПутьКГит());
    Лог.Отладка(Приложение + СтрокаДляЛога);
    
    Если ЭтоWindows = Ложь Тогда 
        СтрокаЗапуска = "sh -c '" + Приложение + СтрокаЗапуска + "'";
    Иначе
        СтрокаЗапуска = Приложение + СтрокаЗапуска;
    КонецЕсли;
    ЗапуститьПриложение(СтрокаЗапуска, ПолучитьРабочийКаталог(), Истина, КодВозврата);
    
    Возврат КодВозврата;
    
КонецФункции

Функция ОбернутьВКавычки(Знач Строка)
    
    //NOTICE: https://github.com/oscript-library/v8runner 
    //Apache 2.0 
    
    Если Лев(Строка, 1) = """" и Прав(Строка, 1) = """" Тогда
        Возврат Строка;
    Иначе
        Возврат """" + Строка + """";
    КонецЕсли;
    
КонецФункции

Процедура Инициализация()
    
    Лог = Логирование.ПолучитьЛог("oscript.lib.gitrunner");
    Лог.УстановитьУровень(УровниЛога.Отладка);
    
    СистемнаяИнформация = Новый СистемнаяИнформация;
    ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;
    
    УстановитьПутьКГит("git");
    
КонецПроцедуры

Инициализация();
