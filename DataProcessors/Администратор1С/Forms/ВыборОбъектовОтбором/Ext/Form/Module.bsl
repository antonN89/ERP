﻿
// Обработчики событий формы.

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
	
	ИмяТаблицыДанных = Параметры.ИмяТаблицы;
	ТекущийОбъект = ОбъектОбработка();
	ЗаголовокТаблицы  = "";
	
	// Определяемся, что за таблица к нам пришла.
	Описание = ТекущийОбъект.ХарактеристикиПоМетаданным(ИмяТаблицыДанных);
	МетаИнфо = Описание.Метаданные;
	Заголовок = МетаИнфо.Представление();
	
	// Список и колонки
	СтруктураДанных = "";
	Если Описание.ЭтоСсылка Тогда
		ЗаголовокТаблицы = МетаИнфо.ПредставлениеОбъекта;
		Если ПустаяСтрока(ЗаголовокТаблицы) Тогда
			ЗаголовокТаблицы = Заголовок;
		КонецЕсли;
		
		СписокДанных.ПроизвольныйЗапрос = Ложь;
		СписокДанных.ОсновнаяТаблица = ИмяТаблицыДанных;
		
		Поле = СписокДанных.Отбор.ДоступныеПоляОтбора.Элементы.Найти(Новый ПолеКомпоновкиДанных("Ссылка"));
		ТаблицаКолонок = Новый ТаблицаЗначений;
		Колонки = ТаблицаКолонок.Колонки;
		Колонки.Добавить("Ссылка", Поле.ТипЗначения, ЗаголовокТаблицы);
		СтруктураДанных = "Ссылка";
		
		КлючФормыДанных = "Ссылка";
		
	ИначеЕсли Описание.ЭтоНабор Тогда
		Колонки = ТекущийОбъект.ИзмеренияНабораЗаписей(МетаИнфо);
		Для Каждого ТекущийЭлементКолонки Из Колонки Цикл
			СтруктураДанных = СтруктураДанных + "," + ТекущийЭлементКолонки.Имя;
		КонецЦикла;
		СтруктураДанных = Сред(СтруктураДанных, 2);
		
		СписокДанных.ПроизвольныйЗапрос = Истина;
		СписокДанных.ТекстЗапроса = "ВЫБРАТЬ РАЗЛИЧНЫЕ " + СтруктураДанных + " ИЗ " + ИмяТаблицыДанных;
		
		Если Описание.ЭтоПоследовательность Тогда
			КлючФормыДанных = "Регистратор";
		Иначе
			КлючФормыДанных = Новый Структура(СтруктураДанных);
		КонецЕсли;
			
	Иначе
		// Без колонок???
		Возврат;
	КонецЕсли;
	СписокДанных.ДинамическоеСчитываниеДанных = Истина;
	
	ТекущийОбъект.ДобавитьКолонкиВТаблицуФормы(
		Элементы.СписокДанных, 
		"Порядок, Отбор, Группировка, СтандартнаяКартинка, Параметры, УсловноеОформление",
		Колонки);
		
КонецПроцедуры

// Обработчики событий элементов шапки формы.

&НаКлиенте
Процедура ОтборПриИзменении(Элемент)
	
	Элементы.СписокДанных.Обновить();
	
КонецПроцедуры

// Обработчики событий элементов таблицы формы список данных.

&НаКлиенте
Процедура СписокДанныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуТекущегоОбъекта();
КонецПроцедуры

// Обработчики команд формы.

&НаКлиенте
Процедура ОткрытьТекущийОбъект(Команда)
	ОткрытьФормуТекущегоОбъекта();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОтобранныеЗначения(Команда)
	ПроизвестиВыбор(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьТекущуюСтроку(Команда)
	ПроизвестиВыбор(Ложь);
КонецПроцедуры

// Служебные процедуры и функции.

&НаКлиенте
Процедура ОткрытьФормуТекущегоОбъекта()
	ТекПараметры = ПараметрыФормыТекущегоОбъекта(Элементы.СписокДанных.ТекущиеДанные);
	Если ТекПараметры <> Неопределено Тогда
		ОткрытьФорму(ТекПараметры.ИмяФормы, ТекПараметры.Ключ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроизвестиВыбор(ВесьРезультатОтбора = Истина)
	
	Если ВесьРезультатОтбора Тогда
		Данные = ВсеВыбранныеЭлементы();
	Иначе
		Данные = Новый Массив;
		Для Каждого ТекСтрока Из Элементы.СписокДанных.ВыделенныеСтроки Цикл
			Элемент = Новый Структура(СтруктураДанных);
			ЗаполнитьЗначенияСвойств(Элемент, Элементы.СписокДанных.ДанныеСтроки(ТекСтрока));
			Данные.Добавить(Элемент);
		КонецЦикла;
	КонецЕсли;
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ИмяТаблицы", Параметры.ИмяТаблицы);
	СтруктураПараметров.Вставить("ДанныеВыбора", Данные);
	СтруктураПараметров.Вставить("ДействиеВыбора", Параметры.ДействиеВыбора);
	СтруктураПараметров.Вставить("СтруктураПолей", СтруктураДанных);
	ОповеститьОВыборе(СтруктураПараметров);
КонецПроцедуры

&НаСервере
Функция ОбъектОбработка(ТекущийОбъект = Неопределено) 
	Если ТекущийОбъект = Неопределено Тогда
		Возврат РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	Возврат Неопределено;
КонецФункции

&НаСервере
Функция ПараметрыФормыТекущегоОбъекта(Знач Данные)
	
	Если Данные = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(КлючФормыДанных) = Тип("Строка") Тогда
		Значение = Данные[КлючФормыДанных];
		ТекИмяФормы = ОбъектОбработка().ПолучитьИмяФормы(Значение) + ".ФормаОбъекта";
	Иначе
		// Там структура с именами измерений.
		Если Данные.Свойство("Регистратор") Тогда
			Значение = Данные.Регистратор;
		Иначе
			ЗаполнитьЗначенияСвойств(КлючФормыДанных, Данные);
			ТекПараметры = Новый Массив;
			ТекПараметры.Добавить(КлючФормыДанных);
			ИмяКлючаЗаписи = СтрЗаменить(Параметры.ИмяТаблицы, ".", "КлючЗаписи.");
			Значение = Новый(ИмяКлючаЗаписи, ТекПараметры);
			ТекИмяФормы = Параметры.ИмяТаблицы + ".ФормаЗаписи";
		КонецЕсли;
		
	КонецЕсли;
	Результат = Новый Структура("ИмяФормы", ТекИмяФормы);
	Результат.Вставить("Ключ", Новый Структура("Ключ", Значение));
	Возврат Результат;
КонецФункции

&НаСервере
Функция ВсеВыбранныеЭлементы()
	
	Данные = ОбъектОбработка().ТекущиеДанныеДинамическогоСписка(СписокДанных);
	
	Результат = Новый Массив();
	Для Каждого ТекСтрока Из Данные Цикл
		Элемент = Новый Структура(СтруктураДанных);
		ЗаполнитьЗначенияСвойств(Элемент, ТекСтрока);
		Результат.Добавить(Элемент);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции	
