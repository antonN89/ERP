﻿//{{20210114 ГлазуновДВ
&Вместо("ТоварыПередНачаломДобавления")
Процедура Рин1_ТоварыПередНачаломДобавления(Форма, Элемент, Отказ, Копирование, КэшированныеЗначения)
	ИменаРеквизитов = РасхожденияКлиентСервер.ИменаРеквизитовВЗависимостиОтТипаАкта(ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.АктОРасхожденияхПослеОтгрузки"));
	
	ТекущиеДанные = Форма.Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Копирование И ТекущиеДанные[ИменаРеквизитов.ЗаполненоПоОснованию] Тогда
		Отказ = Истина;
		
		НоваяСтрока = Форма.Объект.Товары.Добавить();
		СтрокаИсключаемыхСвойств = ИменаРеквизитов.ЗаполненоПоОснованию 
		                           + ", КоличествоПоДокументу, КоличествоУпаковокПоДокументу, СуммаПоДокументу, СуммаНДСПоДокументу, СуммаСНДСПоДокументу, КодСтроки";
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные, , СтрокаИсключаемыхСвойств);
	//{{20210114 ГлазуновДВ Задача 3905 добавили для Заполнения колонки "Назначение" в ТЧ "Товары" При Копировании строки "АктаРасхожденияПослеПриемки"
		Попытка
			Если ТекущиеДанные.СпецНазначение = ПредопределенноеЗначение("Справочник.Назначения.ЗаменаБрака") Тогда
				НоваяСтрока.Назначение = ПредопределенноеЗначение("Справочник.Назначения.ЗаменаБрака");
				НоваяСтрока.СпецНазначение = ПредопределенноеЗначение("Справочник.Назначения.ПустаяСсылка");
				НоваяСтрока.Действие = Неопределено;
				НоваяСтрока.КоличествоУпаковокРасхождения = 0;
				НоваяСтрока.Количество = 0;
				НоваяСтрока.КоличествоУпаковок = 0;
			КонецЕсли;
		Исключение
		КонецПопытки;
	//}}20210114 ГлазуновДВ
		
		Форма.Элементы.Товары.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		РасхожденияКлиент.ТоварыКоличествоУпаковокПриИзменении(Форма, КэшированныеЗначения);
		РасхожденияКлиентСервер.УправлениеДоступностью(Форма);
		
	КонецЕсли;
	
КонецПроцедуры
//}}20210114 ГлазуновДВ
