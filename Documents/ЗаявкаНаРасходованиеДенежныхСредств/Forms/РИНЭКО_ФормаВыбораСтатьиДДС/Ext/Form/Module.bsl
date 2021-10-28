﻿
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ЗакрытьФорму();
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	ЗакрытьФорму();	
КонецПроцедуры


&НаКлиенте
Процедура ЗакрытьФорму()
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() = 0 Тогда
		
		Сообщить("Нет выделенных строк");
		Возврат;
		
	КонецЕсли;
	
	Если ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(Элементы.Список.ВыделенныеСтроки[0],"ЭтоГруппа") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(Элементы.Список.ВыделенныеСтроки[0],"ПометкаУдаления") Тогда
		Описание = Новый ОписаниеОповещения("ВопросЗавершение",ЭтотОбъект);
		ПоказатьВопрос(Описание,"Данный элемент справочника помечен на удаление продолжить выбор ?",РежимДиалогаВопрос.ДаНет);
	Иначе 
		ЭтаФорма.Закрыть(Элементы.Список.ВыделенныеСтроки);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗавершение(Результат,Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЭтаФорма.Закрыть(Элементы.Список.ВыделенныеСтроки);			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.Список.КоманднаяПанель.ПодчиненныеЭлементы.СписокСоздатьГруппу.Видимость = Ложь;	
КонецПроцедуры
