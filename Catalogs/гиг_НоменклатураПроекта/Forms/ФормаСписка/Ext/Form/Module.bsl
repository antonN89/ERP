﻿&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ВариантыПараметров.УсловноеОформление.Элементы.Очистить();
	
	Если ЗначениеЗаполнено(ОсновнойВариантПараметров) Тогда
		
		Элемент = ВариантыПараметров.УсловноеОформление.Элементы.Добавить();
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Ссылка");
		ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = ОсновнойВариантПараметров;

		НовыйШрифт = Новый Шрифт(Элементы.ВариантыПараметров.Шрифт, , , Истина);
		Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", НовыйШрифт);
		
	КонецЕсли;
	
	Элемент = ВариантыПараметров.УсловноеОформление.Элементы.Добавить();
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Ссылка");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Справочники.гиг_ВариантыПараметровНоменклатурыПроекта.ПустаяСсылка();
	
	НовыйЦвет = Новый Цвет(192, 192, 192);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", НовыйЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	
	ВариантыРасчетов.УсловноеОформление.Элементы.Очистить();
	
	Если ЗначениеЗаполнено(ОсновнойВариантРасчетов) Тогда
		
		Элемент = ВариантыРасчетов.УсловноеОформление.Элементы.Добавить();
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Ссылка");
		ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = ОсновнойВариантРасчетов;

		НовыйШрифт = Новый Шрифт(Элементы.ВариантыРасчетов.Шрифт, , , Истина);
		Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", НовыйШрифт);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОсновныеЗначения(НоменклатураПроекта)

	Если ЗначениеЗаполнено(НоменклатураПроекта) Тогда
		Результат = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НоменклатураПроекта, "ОсновнойВариантПараметров, ОсновнойВариантРасчетов");
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Результат);
	Иначе
		 ОсновнойВариантПараметров = Неопределено;
		 ОсновнойВариантРасчетов   = Неопределено;
	КонецЕсли; 
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры  

&НаКлиенте
Процедура УстановитьОтборНоменклатураПроекта()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ВариантыПараметров, "НоменклатураПроекта", НоменклатураПроекта, ВидСравненияКомпоновкиДанных.Равно, , Истина);//НоменклатураПроекта, ВидСравненияКомпоновкиДанных.Равно, , ЗначениеЗаполнено(НоменклатураПроекта));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтрокиНаКлиенте()
	
	НоменклатураПроекта = Элементы.Список.ТекущаяСтрока;
	УстановитьОтборНоменклатураПроекта();
	ВариантыПараметровПриАктивизацииСтрокиНаКлиенте();
	
	ОбновитьОсновныеЗначения(НоменклатураПроекта);
	
КонецПроцедуры
 
&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	СписокПриАктивизацииСтрокиНаКлиенте();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОсновнойВариантПараметровНаСервере(СсылкаНаВариантПараметров)
	
	ОсновнойВариантПараметров = СсылкаНаВариантПараметров;
	
	НоменклатураПроектаОбъект = Элементы.Список.ТекущаяСтрока.ПолучитьОбъект();
	НоменклатураПроектаОбъект.ОсновнойВариантПараметров = ОсновнойВариантПараметров;
	НоменклатураПроектаОбъект.Записать();
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОсновнойВариантПараметров(Команда)
	
	Если Не ЗначениеЗаполнено(Элементы.ВариантыПараметров.ТекущаяСтрока) Тогда
		Возврат;
	КонецЕсли; 
	
	ТекущаяСтрока = Элементы.ВариантыПараметров.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущаяСтрока.Ссылка) Тогда
		УстановитьОсновнойВариантПараметровНаСервере(ТекущаяСтрока.Ссылка);
	Иначе
		ПоказатьПредупреждение(, "Основным может быть только созданный элемент! Вы выбрали элемент, который не записан в базу данных!");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОсновнойВариантРасчетовНаСервере()
	
	ОсновнойВариантРасчетов = Элементы.ВариантыРасчетов.ТекущаяСтрока;
	
	НоменклатураПроектаОбъект = Элементы.Список.ТекущаяСтрока.ПолучитьОбъект();
	НоменклатураПроектаОбъект.ОсновнойВариантРасчетов = ОсновнойВариантРасчетов;
	НоменклатураПроектаОбъект.Записать();
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОсновнойВариантРасчетов(Команда)
	
	Если Не ЗначениеЗаполнено(Элементы.ВариантыРасчетов.ТекущаяСтрока) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьОсновнойВариантРасчетовНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗадачуПроекта(Команда)
	
	ПолеВладелец = Новый ПолеКомпоновкиДанных("Владелец");
	Для каждого Элемент Из Список.Отбор.Элементы Цикл
		Если Элемент.ЛевоеЗначение = ПолеВладелец Тогда
			ТекущийПроект = Элемент.ПравоеЗначение;
		КонецЕсли; 
	КонецЦикла; 
	
	ПараметрыЗадачи = Новый Структура;
	ПараметрыЗадачи.Вставить("ЗначенияЗаполнения", Новый Структура("Владелец", ТекущийПроект));
	
	ОткрытьФорму("Справочник.ЗадачиПроектов.ФормаОбъекта", ПараметрыЗадачи, ЭтаФорма, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗадачуПроекта(ЗадачаПроекта)
	
	Для каждого ВыделеннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		НоменклатураПроектаОбъект = ВыделеннаяСтрока.ПолучитьОбъект();
		НоменклатураПроектаОбъект.ЗадачаПроекта = ЗадачаПроекта;
		НоменклатураПроектаОбъект.Записать();
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	Если ТипЗнч(НовыйОбъект) = Тип("СправочникСсылка.ЗадачиПроектов") Тогда
		ЗаполнитьЗадачуПроекта(НовыйОбъект);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ЗадачаПроекта") Тогда
		
		ЗадачаПроекта = Параметры.ЗадачаПроекта;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ЗадачаПроекта", ЗадачаПроекта, ВидСравненияКомпоновкиДанных.Равно, , ЗначениеЗаполнено(ЗадачаПроекта));
		
		Элементы.ОтборПроект.Видимость = Ложь;
		Элементы.ОтборЗадачаПроекта.Видимость = Ложь;
		
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец") Тогда
		
		Проект = Параметры.Отбор.Владелец;
		
		Элементы.ОтборПроект.Видимость = Ложь;
		ЭтаФорма.АвтоЗаголовок = Ложь;
		ЭтаФорма.Заголовок = "Номенклатура проекта: " + Проект;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ВариантыПараметров, "Владелец", Проект, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Проект));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ВариантыРасчетов,   "Владелец", Проект, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Проект));
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,             "Владелец", Проект, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Проект));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ВариантыПараметров, "Владелец", Проект, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Проект));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ВариантыРасчетов,   "Владелец", Проект, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Проект));
	
	УстановитьОтборНоменклатураПроекта();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачаПроектаПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ЗадачаПроекта", ЗадачаПроекта, ВидСравненияКомпоновкиДанных.Равно, , ЗначениеЗаполнено(ЗадачаПроекта));
	
	НоменклатураПроекта = Элементы.Список.ТекущаяСтрока;
	ВариантПараметров = ?(НоменклатураПроекта = ПредопределенноеЗначение("Справочник.гиг_НоменклатураПроекта.ПустаяСсылка"), ПредопределенноеЗначение("Справочник.гиг_ВариантыПараметровНоменклатурыПроекта.ПустаяСсылка"), Элементы.ВариантыПараметров.ТекущаяСтрока);
	УстановитьОтборНоменклатураПроекта();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьПредметыРасчета(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	ОткрытьФорму("Справочник.гиг_ПредметыРасчета.ФормаВыбора", 
			ПараметрыФормы, 
			ЭтаФорма, 
			УникальныйИдентификатор,,,, 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
КонецПроцедуры

&НаСервере
Процедура СоздатьНоменклатуруПроекта(ПредметРасчета)
	
	Попытка
		
		НачатьТранзакцию();
		
		НовыйЭлемент = Справочники.гиг_НоменклатураПроекта.СоздатьЭлемент();
		НовыйЭлемент.УстановитьСсылкуНового(Справочники.гиг_НоменклатураПроекта.ПолучитьСсылку(Новый УникальныйИдентификатор));
		
		НовыйЭлемент.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПредметРасчета, "Наименование");
		НовыйЭлемент.Владелец     = Проект;
		НовыйЭлемент.Количество   = 1;
		
		
		НовыйВариантПараметров = Справочники.гиг_ВариантыПараметровНоменклатурыПроекта.СоздатьЭлемент();
		НовыйВариантПараметров.Владелец            = Проект;
		НовыйВариантПараметров.Наименование        = "Первичный вариант";
		НовыйВариантПараметров.НоменклатураПроекта = НовыйЭлемент.ПолучитьСсылкуНового();
		
		НоваяСтрока = НовыйВариантПараметров.ЗначенияПараметров.Добавить();
		НоваяСтрока.ПредметРасчета = ПредметРасчета;
		
		НовыйВариантПараметров.Записать();
		
		НовыйЭлемент.ОсновнойВариантПараметров = НовыйВариантПараметров.Ссылка;
		
		НовыйЭлемент.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка добавления номенклатуры проекта." + Символы.ПС + ОписаниеОшибки());
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора <> Неопределено 
		И ТипЗнч(ИсточникВыбора) = Тип("УправляемаяФорма") 
		И ИсточникВыбора.ИмяФормы = "Справочник.гиг_ПредметыРасчета.ФормаВыбора" Тогда
		
		СоздатьНоменклатуруПроекта(ВыбранноеЗначение);
		
		Элементы.Список.Обновить();
		
	ИначеЕсли ИсточникВыбора <> Неопределено 
		И ТипЗнч(ИсточникВыбора) = Тип("УправляемаяФорма") 
		И ИсточникВыбора.ИмяФормы = "Справочник.гиг_НоменклатураПроекта.Форма.ФормаВыбораПредметаРасчета" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("НоменклатураПроекта", Элементы.Список.ТекущаяСтрока);
		ПараметрыФормы.Вставить("ПредметРасчета", ВыбранноеЗначение);
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", Новый Структура("Владелец", Проект));
		ОписаниеОповещения = Новый ОписаниеОповещения("СоздатьВариантПараметровОбработкаОповещения", ЭтотОбъект);
		ОткрытьФорму("Справочник.гиг_ВариантыПараметровНоменклатурыПроекта.ФормаОбъекта", 
			ПараметрыФормы,
			ЭтаФорма, 
			УникальныйИдентификатор,,,
			ОписаниеОповещения,
			РежимОткрытияОкнаФормы.Независимый);
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ВариантыПараметровПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НоменклатураПроекта", Элементы.Список.ТекущаяСтрока);
	
	ОткрытьФорму("Справочник.гиг_НоменклатураПроекта.Форма.ФормаВыбораПредметаРасчета", 
		ПараметрыФормы, 
		ЭтаФорма, 
		УникальныйИдентификатор,,,, 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Отказ = Истина;
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборВариантПараметровНоменклатураПроекта()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ВариантыРасчетов,   "НоменклатураПроекта", НоменклатураПроекта, ВидСравненияКомпоновкиДанных.Равно, , Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ВариантыРасчетов,   "ВариантПараметров", ВариантПараметров, ВидСравненияКомпоновкиДанных.Равно, , Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантыПараметровПриАктивизацииСтрокиНаКлиенте()
	
	НоменклатураПроекта = Элементы.Список.ТекущаяСтрока;
	ТекСтрока = Элементы.ВариантыПараметров.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		ВариантПараметров = ПредопределенноеЗначение("Справочник.гиг_ВариантыПараметровНоменклатурыПроекта.ПустаяСсылка");
	Иначе
		ВариантПараметров = ?(НоменклатураПроекта = ПредопределенноеЗначение("Справочник.гиг_НоменклатураПроекта.ПустаяСсылка"), ПредопределенноеЗначение("Справочник.гиг_ВариантыПараметровНоменклатурыПроекта.ПустаяСсылка"), ТекСтрока.Ссылка);
	КонецЕсли;
	УстановитьОтборВариантПараметровНоменклатураПроекта();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантыПараметровПриАктивизацииСтроки(Элемент)
	
	ВариантыПараметровПриАктивизацииСтрокиНаКлиенте();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СформироватьВариантыПараметровНаСервере(НомПроекта, СЗ_Идентификатор)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗадачиПроектовгиг_ЗначенияПараметров.НаименованиеВариантаПараметров КАК НаименованиеВариантаПараметров,
	|	ЗадачиПроектовгиг_ЗначенияПараметров.ИдентификаторВариантаПараметров КАК ИдентификаторВариантаПараметров,
	|	ЗадачиПроектовгиг_ЗначенияПараметров.Ссылка.ГИГ_ПредметРасчета КАК ПредметРасчета,
	|	ЗадачиПроектовгиг_ЗначенияПараметров.ПараметрПредметаРасчета КАК ПараметрПредметаРасчета,
	|	ЗадачиПроектовгиг_ЗначенияПараметров.ЗначениеПараметра КАК ЗначениеПараметра,
	|	ЕСТЬNULL(ВложенныйЗапрос.Ссылка, ЗНАЧЕНИЕ(Справочник.гиг_ВариантыПараметровНоменклатурыПроекта.ПустаяСсылка)) КАК Ссылка
	|ИЗ
	|	Справочник.ЗадачиПроектов.гиг_ЗначенияПараметров КАК ЗадачиПроектовгиг_ЗначенияПараметров
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			гиг_ВариантыПараметровНоменклатурыПроекта.Ссылка КАК Ссылка,
	|			гиг_ВариантыПараметровНоменклатурыПроекта.НоменклатураПроекта КАК НоменклатураПроекта,
	|			гиг_ВариантыПараметровНоменклатурыПроекта.Идентификатор КАК Идентификатор
	|		ИЗ
	|			Справочник.гиг_ВариантыПараметровНоменклатурыПроекта КАК гиг_ВариантыПараметровНоменклатурыПроекта
	|		ГДЕ
	|			гиг_ВариантыПараметровНоменклатурыПроекта.НоменклатураПроекта = &НоменклатураПроекта) КАК ВложенныйЗапрос
	|		ПО ЗадачиПроектовгиг_ЗначенияПараметров.ИдентификаторВариантаПараметров = ВложенныйЗапрос.Идентификатор
	|ГДЕ
	|	ЗадачиПроектовгиг_ЗначенияПараметров.Ссылка = &Ссылка
	|	И ЗадачиПроектовгиг_ЗначенияПараметров.ИдентификаторВариантаПараметров В(&СЗ_Идентификатор)
	|ИТОГИ
	|	МАКСИМУМ(НаименованиеВариантаПараметров),
	|	МАКСИМУМ(Ссылка)
	|ПО
	|	ИдентификаторВариантаПараметров";
	
	Запрос.УстановитьПараметр("Ссылка", НомПроекта.ЗадачаПроекта);
	Запрос.УстановитьПараметр("НоменклатураПроекта", НомПроекта);
	
	Запрос.УстановитьПараметр("СЗ_Идентификатор", СЗ_Идентификатор);
	
	Проект = НомПроекта.Владелец;
	
	Результат = Запрос.Выполнить();

	ВыборкаПоИдентификаторам = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоИдентификаторам.Следующий() Цикл
		Если ЗначениеЗаполнено(ВыборкаПоИдентификаторам.Ссылка) Тогда
			НовыйВариант = ВыборкаПоИдентификаторам.Ссылка.ПолучитьОбъект();
		Иначе
			НовыйВариант = Справочники.гиг_ВариантыПараметровНоменклатурыПроекта.СоздатьЭлемент();
		КонецЕсли;
		НовыйВариант.Владелец = Проект;
		НовыйВариант.Наименование = ВыборкаПоИдентификаторам.НаименованиеВариантаПараметров;
		НовыйВариант.Идентификатор = ВыборкаПоИдентификаторам.ИдентификаторВариантаПараметров;
		НовыйВариант.НоменклатураПроекта = НомПроекта;
		НовыйВариант.ЗначенияПараметров.Очистить();
		Выборка = ВыборкаПоИдентификаторам.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = НовыйВариант.ЗначенияПараметров.Добавить();
			НоваяСтрока.ПредметРасчета = Выборка.ПредметРасчета;
			НоваяСтрока.ЗначениеПараметра = Выборка.ЗначениеПараметра;
		КонецЦикла;
		Попытка
			НовыйВариант.Записать();
		Исключение
			ОписаниеОшибки = ОписаниеОшибки();
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не удалось записать вариант параметров номенклатуры проекта!
			|Причина: " + ОписаниеОшибки;
			Сообщение.Сообщить();
		КонецПопытки;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьВариантыПараметров(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//bercut040719
	СЗ_Идентификатор = Новый СписокЗначений;
	Для каждого СтрокаСписка Из Элементы.ВариантыПараметров.ВыделенныеСтроки Цикл
		Идентификатор = Элементы.ВариантыПараметров.ДанныеСтроки(СтрокаСписка).Идентификатор;
		СЗ_Идентификатор.Добавить(Идентификатор);
	КонецЦикла;
	//
	
	СформироватьВариантыПараметровНаСервере(Элементы.Список.ТекущаяСтрока, СЗ_Идентификатор);
	СписокПриАктивизацииСтрокиНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВариантПараметров(Команда) 
	
	Если ПолучитьРасчетИзделий() Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("НоменклатураПроекта", Элементы.Список.ТекущаяСтрока);
		
		ОткрытьФорму("Справочник.гиг_НоменклатураПроекта.Форма.ФормаВыбораПредметаРасчета", 
		ПараметрыФормы, 
		ЭтаФорма, 
		УникальныйИдентификатор,,,, 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Иначе 
		Сообщить("В проекте отключен расчет изделий (Включите расчет изделий и запишите проект). Создание варианта параметров запрещено!");
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПредметРасчетаИзЗадачиНоменклатурыПроекта(СтрокаНоменклатурыПроекта)
	Возврат СтрокаНоменклатурыПроекта.ЗадачаПроекта.ГИГ_ПредметРасчета;
КонецФункции

&НаКлиенте
Процедура СкопироватьВариантПараметров(Команда)
	
	ТекущаяСтрока = Элементы.ВариантыПараметров.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущаяСтрока.Ссылка) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("НоменклатураПроекта", Элементы.Список.ТекущаяСтрока);
		ПараметрыФормы.Вставить("ПредметРасчета", ПолучитьПредметРасчетаИзЗадачиНоменклатурыПроекта(Элементы.Список.ТекущаяСтрока));
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", Новый Структура("Владелец", Проект));
		ПараметрыФормы.Вставить("ОбъектКопирования", ТекущаяСтрока.Ссылка);
		ОписаниеОповещения = Новый ОписаниеОповещения("СоздатьВариантПараметровОбработкаОповещения", ЭтотОбъект);
		ОткрытьФорму("Справочник.гиг_ВариантыПараметровНоменклатурыПроекта.ФормаОбъекта", 
			ПараметрыФормы,
			ЭтаФорма, 
			УникальныйИдентификатор,,,
			ОписаниеОповещения, 
			РежимОткрытияОкнаФормы.Независимый);
	Иначе
		ПоказатьПредупреждение(, "Скопировать можно только созданный элемент! Вы выбрали элемент, который не записан в базу данных!");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВариантПараметровОбработкаОповещения(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Элементы.ВариантыПараметров.Обновить();
	СписокПриАктивизацииСтрокиНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантыПараметровВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекСтрока = Элементы.ВариантыПараметров.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекСтрока.Ссылка) Тогда
		ПараметрыФормы = Новый Структура("Ключ", ТекСтрока.Ссылка);
		ОткрытьФорму("Справочник.гиг_ВариантыПараметровНоменклатурыПроекта.ФормаОбъекта",
			ПараметрыФормы,
			ЭтаФорма,
			УникальныйИдентификатор,,,,
			РежимОткрытияОкнаФормы.Независимый);
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения("ВариантыПараметровВыборОбработкаОповещения", ЭтотОбъект);
		НоменклатураПроекта = Элементы.Список.ТекущаяСтрока;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("НоменклатураПроекта", НоменклатураПроекта);
		ПараметрыФормы.Вставить("Идентификатор", ТекСтрока.Идентификатор);
		ОткрытьФорму("Справочник.гиг_ВариантыПараметровНоменклатурыПроекта.ФормаОбъекта",
			ПараметрыФормы,
			ЭтаФорма,
			УникальныйИдентификатор,,,
			ОписаниеОповещения,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантыПараметровВыборОбработкаОповещения(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	СписокПриАктивизацииСтрокиНаКлиенте();
	
КонецПроцедуры

&НаСервере
Процедура ПометитьНаУдалениеВариантПараметровНаСервере(СсылкаНаВариантПараметров)
	
	ОбъектВариантаПараметров = СсылкаНаВариантПараметров.ПолучитьОбъект();
	ОбъектВариантаПараметров.УстановитьПометкуУдаления(Не СсылкаНаВариантПараметров.ПометкаУдаления);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеВариантПараметров(Команда)
	
	ТекущаяСтрока = Элементы.ВариантыПараметров.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущаяСтрока.Ссылка) Тогда
		ПометитьНаУдалениеВариантПараметровНаСервере(ТекущаяСтрока.Ссылка);
		Элементы.ВариантыПараметров.Обновить();
		СписокПриАктивизацииСтрокиНаКлиенте();
	Иначе
		ПоказатьПредупреждение(, "Пометить на удаление / Снять пометку можно только созданный элемент! Вы выбрали элемент, который не записан в базу данных!");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантыРасчетовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если не ПолучитьРасчетИзделий() Тогда
		Отказ = Истина;
		Сообщить("В проекте отключен расчет изделий (Включите расчет изделий и запишите проект). Создание варианта расчетов запрещено!");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если не ПолучитьРасчетИзделий() Тогда
		Отказ = Истина;
		Сообщить("В проекте отключен расчет изделий (Включите расчет изделий и запишите проект). Создание номенклатуры запрещено!");
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРасчетИзделий()

	Возврат Проект.гиг_РасчетИзделий;

КонецФункции //

