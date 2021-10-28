﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ИдентификаторПоследнейВыделеннойСтроки Экспорт; // Идентификатор последней выделенной строки

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	
	УстановитьУсловноеОформление();
	
	Режим = Параметры.Режим;
	Если Параметры.Свойство("РабочиеДанныеИмя") Тогда
		РабочиеДанныеИмя = Параметры.РабочиеДанныеИмя;
	КонецЕсли;
	
	ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	ИмяПользователя = ?(ПустаяСтрока(ТекущийПользователь), НСтр("ru = '<Не авторизован>'; en = '<Not authorized>'"), ТекущийПользователь.ПолноеИмя);
	
	СтрокаПользователь = Настройки.ПолучитьЭлементы().Добавить();
	СтрокаПользователь.Имя = ИмяПользователя;
	СтрокаПользователь.Картинка = Элементы.БиблиотекаКартинокУКО_Пользователь.Картинка;
	СтрокаПользователь.ЭтоНастройка = Ложь;

	Для Каждого Настройка Из ОбъектОбработки().УКО_ДанныеВНастройках_Список() Цикл
		
		СтрокаНастройка = СтрокаПользователь.ПолучитьЭлементы().Добавить();
		СтрокаНастройка.Имя = Настройка;
		СтрокаНастройка.Картинка = Элементы.БиблиотекаКартинокУКО_ТипХраненияДанныхНастройка.Картинка;
		СтрокаНастройка.ЭтоНастройка = Истина;
		
		Если Режим = "Перечисление.УКО_РежимДиалогаУправлениеДаннымиВНастройках.Выбор" И Настройка.Значение = РабочиеДанныеИмя Тогда
			Элементы.Настройки.ТекущаяСтрока = СтрокаНастройка.ПолучитьИдентификатор();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьЭлементыФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НастройкиПриАктивизацииСтроки(Элемент)
	
	ИдентификаторТекущейСтроки = Элементы.Настройки.ТекущаяСтрока;
	
	Если ИдентификаторТекущейСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ИдентификаторПоследнейВыделеннойСтроки <> ИдентификаторТекущейСтроки Тогда 
		
		ИдентификаторПоследнейВыделеннойСтроки = ИдентификаторТекущейСтроки;
		ОбновитьЭлементыФормы();
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИмяНастройкиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	НайденнаяСтрока = НайтиСтроку(Текст);
	Если НайденнаяСтрока <> Неопределено Тогда
		Элементы.Настройки.ТекущаяСтрока = НайденнаяСтрока.ПолучитьИдентификатор();
		ТекущийЭлемент = Элементы.Настройки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные.ЭтоНастройка Тогда

		Если Режим = "Перечисление.УКО_РежимДиалогаУправлениеДаннымиВНастройках.Сохранение" Тогда
			Сохранить (Неопределено);
		ИначеЕсли Режим = "Перечисление.УКО_РежимДиалогаУправлениеДаннымиВНастройках.Загрузка" Тогда
			Загрузить (Неопределено);
		ИначеЕсли Режим = "Перечисление.УКО_РежимДиалогаУправлениеДаннымиВНастройках.Выбор" Тогда
			Выбрать (Неопределено);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Удалить(Команда)
	
	Если РабочиеДанныеИмя = Имя Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Нельзя удалять данные с которыми производится работа'; en = 'You cannot delete data that you are working with'"),,УКО_ОбщегоНазначенияКлиентСервер_ИмяРасширения());
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура("Имя", Имя);
	ТекстВопроса = СтрШаблон(НСтр("ru = 'Будет удалена настройка: %1. Продолжить?'; en = 'This will remove the setting: %1. Continue?'"), Имя);
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ВопросПодтвержденияУдаленияЗавершение", ЭтаФорма, ДополнительныеПараметры),ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да, УКО_ОбщегоНазначенияКлиентСервер_ИмяРасширения());

КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	ТекущиеДанные = Элементы.Настройки.ТекущиеДанные;
	НайденнаяСтрока = НайтиСтроку(Имя);

	ДополнительныеПараметры = Новый Структура("Имя", Имя);
	Если НайденнаяСтрока = Неопределено Тогда
		ВопросСохраненияЗавершение (КодВозвратаДиалога.Да, ДополнительныеПараметры);
	Иначе
		
		ТекстВопроса = СтрШаблон(НСтр("ru = 'Настройка: %1 уже существует. Заменить?'; en = 'Configuration: %1 already exists. Replace?'"), Имя);
		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросСохраненияЗавершение", ЭтаФорма, ДополнительныеПараметры), ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да, УКО_ОбщегоНазначенияКлиентСервер_ИмяРасширения());
		
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	Закрыть(Имя);

КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Закрыть(Имя);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ОбновитьЭлементыФормы()
	
	ТекущиеДанные = Элементы.Настройки.ТекущиеДанные;
	ЭтоГруппаПользователь = (ТекущиеДанные = Неопределено ИЛИ Не ТекущиеДанные.ЭтоНастройка);
	Если Не ЭтоГруппаПользователь Тогда
		Имя = ТекущиеДанные.Имя;
	КонецЕсли;
	
	ДоступностьУдаления = Не ЭтоГруппаПользователь И ЗначениеЗаполнено(Имя);
	
	Если Режим = "Перечисление.УКО_РежимДиалогаУправлениеДаннымиВНастройках.Сохранение" Тогда
		ЗаголовокФормы = НСтр("ru = 'Сохранение данных (в настройки)'; en = 'Saving data (in settings)'");
		Элементы.Сохранить.КнопкаПоУмолчанию = Истина;
	ИначеЕсли Режим = "Перечисление.УКО_РежимДиалогаУправлениеДаннымиВНастройках.Загрузка" Тогда
		ЗаголовокФормы = НСтр("ru = 'Загрузка данных (из настроек)'; en = 'Download data (from settings)'");
		Элементы.Загрузить.КнопкаПоУмолчанию = Истина;
	ИначеЕсли Режим = "Перечисление.УКО_РежимДиалогаУправлениеДаннымиВНастройках.Выбор" Тогда
		ЗаголовокФормы = НСтр("ru = 'Выбор данных (из настроек)'; en = 'Select data (from settings)'");
		Элементы.Выбрать.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
	УКО_ФормыКлиентСервер_Заголовок(ЭтаФорма, ЗаголовокФормы);
	
	Элементы.Сохранить.Видимость = (Режим = "Перечисление.УКО_РежимДиалогаУправлениеДаннымиВНастройках.Сохранение");
	Элементы.Загрузить.Видимость = (Режим = "Перечисление.УКО_РежимДиалогаУправлениеДаннымиВНастройках.Загрузка");
	Элементы.Загрузить.Доступность = Не ЭтоГруппаПользователь;
	Элементы.Выбрать.Видимость = (Режим = "Перечисление.УКО_РежимДиалогаУправлениеДаннымиВНастройках.Выбор");
	Элементы.Выбрать.Доступность = Не ЭтоГруппаПользователь;
	
	Элементы.Удалить.Доступность = ДоступностьУдаления;
	Элементы.КонтекстноеМенюУдалить.Доступность = ДоступностьУдаления;
	
	Элементы.Имя.Видимость = (Режим = "Перечисление.УКО_РежимДиалогаУправлениеДаннымиВНастройках.Сохранение");

КонецФункции

&НаКлиенте
Функция НайтиСтроку(Имя)
	
	Для Каждого Строка Из Настройки.ПолучитьЭлементы()[0].ПолучитьЭлементы() Цикл
		Если Строка.Имя = Имя Тогда
			Возврат Строка;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;

КонецФункции

&НаКлиенте
Процедура ВопросПодтвержденияУдаленияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		УКО_ДанныеВНастройкахВызовСервера_Удалить(ДополнительныеПараметры.Имя);
		Оповестить("ИзмененыПоследниеОткрытыеДанные");

		Имя = "";
		Настройки.ПолучитьЭлементы()[0].ПолучитьЭлементы().Удалить (НайтиСтроку(ДополнительныеПараметры.Имя));
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросСохраненияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Закрыть(ДополнительныеПараметры.Имя);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ОбъектОбработки().УКО_Формы_ДобавитьУсловноеОформление(УсловноеОформление, "Настройки", "Настройки.ЭтоНастройка",
			ВидСравненияКомпоновкиДанных.Равно, Ложь, Новый Структура("Шрифт", УКО_ОбщегоНазначенияКлиентСервер_ШрифтЖирный120()));
	
КонецПроцедуры

#КонецОбласти


&НаСервере
Функция ОбъектОбработки()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции
&НаСервере
// Удаляет данные из хранилища системных настроек по имени
//
// Параметры:
//  Имя  - Строка - Имя настройки данных
//
Процедура УКО_ДанныеВНастройкахВызовСервера_Удалить(Имя) Экспорт
	
	ОбъектОбработки().УКО_ДанныеВНастройках_Удалить(Имя);
	
КонецПроцедуры
&НаКлиентеНаСервереБезКонтекста
// Возвращает имя расширения
// Возвращаемое значение:
//   Строка	- Имя расширения
Функция УКО_ОбщегоНазначенияКлиентСервер_ИмяРасширения() Экспорт 
	
	Возврат НСтр("ru = 'Управляемая консоль отчетов'; en = 'Managed reporting console'");
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает шрифт жирный 120%
// Возвращаемое значение:
//   Шрифт - Шрифт
Функция УКО_ОбщегоНазначенияКлиентСервер_ШрифтЖирный120() Экспорт
	Возврат Новый Шрифт(,,Истина,,,,120);
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Обновляет заголовок формы
//
// Параметры:
//  Форма - Форма - Форма
//  Заголовок - Строка - Заголовок формы
//  Дополнение - Булево - Дополнять заголовок названием расширения
//
Процедура УКО_ФормыКлиентСервер_Заголовок(Форма, Заголовок, Дополнение = Ложь) Экспорт
	
	НовыйЗаголовок = Заголовок;
	
	Если Дополнение Тогда
		НовыйЗаголовок = НовыйЗаголовок + " : " + УКО_ОбщегоНазначенияКлиентСервер_ИмяРасширения();
	КонецЕсли;
	
	Форма.Заголовок = НовыйЗаголовок;
	
КонецПроцедуры
