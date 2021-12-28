﻿
&Вместо("ОграниченияСкидокНаценок")
Функция Рин1_ОграниченияСкидокНаценок(СоглашениеСКлиентом, Пользователь)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИспользоватьРучныеСкидки                     = ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиВПродажах");
	ИспользоватьЦеновыеГруппы                    = ПолучитьФункциональнуюОпцию("ИспользоватьЦеновыеГруппы");
	ИспользоватьОграниченияРучныхСкидокВПродажах = ПолучитьФункциональнуюОпцию("ИспользоватьОграниченияРучныхСкидокВПродажахПоПользователям");
	
	Если ЗначениеЗаполнено(СоглашениеСКлиентом) Тогда
		ИспользоватьОграниченияПоСоглашениям         = ПолучитьФункциональнуюОпцию("ИспользоватьОграниченияРучныхСкидокВПродажахПоСоглашениям");
	Иначе
		ИспользоватьОграниченияПоСоглашениям = Ложь;
	КонецЕсли;
	
	ОграничиватьРучныеСкидки                     = ИспользоватьРучныеСкидки И (ИспользоватьОграниченияРучныхСкидокВПродажах ИЛИ ИспользоватьОграниченияПоСоглашениям);
	
	МассивПроверок = Новый Массив;
	
	Если ОграничиватьРучныеСкидки Тогда
		Если ИспользоватьОграниченияРучныхСкидокВПродажах Тогда
			МассивПроверок.Добавить("ВременнаяТаблицаОграничениеРучныхСкидокГруппыПользователей");
			МассивПроверок.Добавить("ВременнаяТаблицаОграничениеРучныхСкидокОграниченияПоГруппамПользователей");
			МассивПроверок.Добавить("ВременнаяТаблицаОграничениеРучныхСкидокОграниченияПоГруппамИПользователям");
		КонецЕсли;
		МассивПроверок.Добавить("ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения");
		МассивПроверок.Добавить("ВременнаяТаблицаОграниченияРучныхСкидок");
		МассивПроверок.Добавить("ОграниченияРучныхСкидокНаценок");
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	ТекстЗапроса     = "";
	Для Каждого ТекЭлемент Из МассивПроверок Цикл
		
		Если  ТекЭлемент = "ВременнаяТаблицаОграничениеРучныхСкидокГруппыПользователей" Тогда
			
			СформироватьЗапросВременнаяТаблицаОграничениеРучныхСкидокГруппыПользователей(ТекстЗапроса);
			
		ИначеЕсли  ТекЭлемент = "ВременнаяТаблицаОграничениеРучныхСкидокОграниченияПоГруппамПользователей" Тогда
			
			СформироватьЗапросВременнаяТаблицаОграничениеРучныхСкидокОграниченияПоГруппамПользователей(ТекстЗапроса, ИспользоватьЦеновыеГруппы);
			
		ИначеЕсли  ТекЭлемент = "ВременнаяТаблицаОграничениеРучныхСкидокОграниченияПоГруппамИПользователям" Тогда
			
			СформироватьЗапросВременнаяТаблицаОграничениеРучныхСкидокОграниченияПоГруппамИПользователям(ТекстЗапроса, ИспользоватьЦеновыеГруппы);
			
		ИначеЕсли  ТекЭлемент = "ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения" Тогда
			
			СформироватьЗапросВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения(ТекстЗапроса, ИспользоватьЦеновыеГруппы, ИспользоватьОграниченияРучныхСкидокВПродажах, ИспользоватьОграниченияПоСоглашениям);
			
		ИначеЕсли  ТекЭлемент = "ВременнаяТаблицаОграниченияРучныхСкидок" Тогда
			
			//++Гольм А.А. (Гигабайт) 20.11.2018 10:22:23
			//СформироватьЗапросВременнаяТаблицаОграниченияРучныхСкидок(ТекстЗапроса);
			Рин1_СформироватьЗапросВременнаяТаблицаОграниченияРучныхСкидок(ТекстЗапроса, ИспользоватьОграниченияПоСоглашениям);
			//--Гольм А.А. (Гигабайт) 20.11.2018 10:22:41
			
		ИначеЕсли ТекЭлемент = "ОграниченияРучныхСкидокНаценок" Тогда
			
			//++Гольм А.А. (Гигабайт) 20.11.2018 10:23:03
			//СформироватьЗапросОграниченияРучныхСкидокНаценок(ТекстЗапроса);
			Рин1_СформироватьЗапросОграниченияРучныхСкидокНаценок(ТекстЗапроса, ИспользоватьОграниченияПоСоглашениям);
			//--Гольм А.А. (Гигабайт) 20.11.2018 10:23:13
			
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Если ИспользоватьОграниченияПоСоглашениям Тогда
		Запрос.УстановитьПараметр("СоглашениеСКлиентом", СоглашениеСКлиентом);
	КонецЕсли;
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&Вместо("СформироватьЗапросВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения")
Процедура Рин1_СформироватьЗапросВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения(ТекстЗапроса, ИспользоватьЦеновыеГруппы, ИспользоватьОграниченияПоПользователям, ИспользоватьОграниченияПоСоглашениям)
	
	ИмяВременнойТаблицы = "ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения";
	Если ИспользоватьОграниченияПоПользователям Тогда
		
		ТекстЗапроса = ТекстЗапроса + 
		"ВЫБРАТЬ
		|	ЦеновыеГруппы.Ссылка КАК Ссылка,
		|	0.00                 КАК ПроцентРучнойСкидки,
		|	0.00                 КАК ПроцентРучнойНаценки
		|ПОМЕСТИТЬ ЦеновыеГруппы
		|ИЗ
		|	Справочник.ЦеновыеГруппы КАК ЦеновыеГруппы
		|	
		|ОБЪЕДИНИТЬ ВСЕ
		|			
		|ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(Справочник.ЦеновыеГруппы.ПустаяСсылка),
		|	0.00 КАК ПроцентРучнойСкидки,
		|	0.00 КАК ПроцентРучнойНаценки
		|;
		|
		|///////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МИНИМУМ(ВременнаяТаблицаОграничениеРучныхСкидокОграниченияПоГруппамИПользователям.Приоритет) КАК Приоритет,
		|	ВременнаяТаблицаОграничениеРучныхСкидокОграниченияПоГруппамИПользователям.ЦеноваяГруппа      КАК ЦеноваяГруппа
		|ПОМЕСТИТЬ ОграничениеРучныхСкидокПоГруппамИПользователям
		|ИЗ
		|	ВременнаяТаблицаОграничениеРучныхСкидокОграниченияПоГруппамИПользователям КАК ВременнаяТаблицаОграничениеРучныхСкидокОграниченияПоГруппамИПользователям
		|	
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаОграничениеРучныхСкидокОграниченияПоГруппамИПользователям.ЦеноваяГруппа
		|;
		|
		|///////////////////////////////////////////////////////////
		|ВЫБРАТЬ 
		|	Таблица.ЦеноваяГруппа                  КАК ЦеноваяГруппа,
		|	МАКСИМУМ(Таблица.ПроцентРучнойСкидки)  КАК ПроцентРучнойСкидки,
		|	МАКСИМУМ(Таблица.ПроцентРучнойНаценки) КАК ПроцентРучнойНаценки
		|ПОМЕСТИТЬ ТаблицаОграничений
		|ИЗ
		|	(ВЫБРАТЬ
		|		Ограничения.ЦеноваяГруппа        КАК ЦеноваяГруппа,
		|		Ограничения.ПроцентРучнойСкидки  КАК ПроцентРучнойСкидки,
		|		Ограничения.ПроцентРучнойНаценки КАК ПроцентРучнойНаценки
		|	ИЗ
		|		ОграничениеРучныхСкидокПоГруппамИПользователям
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаОграничениеРучныхСкидокОграниченияПоГруппамИПользователям КАК Ограничения
		|		ПО (Ограничения.ЦеноваяГруппа = ОграничениеРучныхСкидокПоГруппамИПользователям.ЦеноваяГруппа)
		|			И (Ограничения.Приоритет = ОграничениеРучныхСкидокПоГруппамИПользователям.Приоритет)
		|	
		//|	ОБЪЕДИНИТЬ ВСЕ
		//|	
		//|	ВЫБРАТЬ
		//|		ЗНАЧЕНИЕ(Справочник.ЦеновыеГруппы.ПустаяСсылка) КАК ЦеноваяГруппа,
		//|		0.00 КАК ПроцентРучнойСкидки,
		//|		0.00 КАК ПроцентРучнойНаценки
		|	
		|) КАК Таблица
		|
		|СГРУППИРОВАТЬ ПО
		|	Таблица.ЦеноваяГруппа
		|;
		|
		|///////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЦеновыеГруппы.Ссылка                                                                        КАК ЦеноваяГруппа,
		|	ЕСТЬNULL(ТаблицаОграничений.ПроцентРучнойСкидки,  ТаблицаОграничений0.ПроцентРучнойСкидки)  КАК ПроцентРучнойСкидки,
		|	ЕСТЬNULL(ТаблицаОграничений.ПроцентРучнойНаценки, ТаблицаОграничений0.ПроцентРучнойНаценки) КАК ПроцентРучнойНаценки
		|ПОМЕСТИТЬ " + ИмяВременнойТаблицы + "
		|ИЗ ЦеновыеГруппы
		|ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОграничений
		|ПО ТаблицаОграничений.ЦеноваяГруппа = ЦеновыеГруппы.Ссылка 
		|
		|ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОграничений КАК ТаблицаОграничений0
		|ПО ТаблицаОграничений0.ЦеноваяГруппа = ЗНАЧЕНИЕ(Справочник.ЦеновыеГруппы.ПустаяСсылка)";
		
	КонецЕсли;
	
	Если ИспользоватьОграниченияПоСоглашениям Тогда
		
		Если ИспользоватьОграниченияПоПользователям Тогда
			ТекстЗапроса = ТекстЗапроса + "
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|";
		КонецЕсли;
		
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(Справочник.ЦеновыеГруппы.ПустаяСсылка) КАК ЦеноваяГруппа,
		//++Гольм А.А. (Гигабайт)
		// начало доп настройки
		|	ЛОЖЬ КАК Деактивирован,
		// окончание доп настройки
		//--Гольм А.А. (Гигабайт)
		|	СоглашенияСКлиентами.ПроцентРучнойСкидки        КАК ПроцентРучнойСкидки,
		|	СоглашенияСКлиентами.ПроцентРучнойНаценки       КАК ПроцентРучнойНаценки";

		Если Не ИспользоватьОграниченияПоПользователям Тогда
			ТекстЗапроса = ТекстЗапроса + "
			|ПОМЕСТИТЬ " + ИмяВременнойТаблицы;
		КонецЕсли;
		ТекстЗапроса = ТекстЗапроса + "
		|ИЗ
		|	Справочник.СоглашенияСКлиентами КАК СоглашенияСКлиентами
		|ГДЕ
		|	СоглашенияСКлиентами.Ссылка = &СоглашениеСКлиентом
		|	И СоглашенияСКлиентами.ОграничиватьРучныеСкидки
		|";
		
		Если ИспользоватьЦеновыеГруппы Тогда
			
			ТекстЗапроса = ТекстЗапроса + "
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	СправочникЦеновыеГруппы.Ссылка                  КАК ЦеноваяГруппа,
			//++Гольм А.А. (Гигабайт)
			// начало доп настройки
			|    ЛОЖЬ,
			// окончание доп настройки
			//--Гольм А.А. (Гигабайт)
			|	СоглашенияСКлиентами.ПроцентРучнойСкидки        КАК ПроцентРучнойСкидки,
			|	СоглашенияСКлиентами.ПроцентРучнойНаценки       КАК ПроцентРучнойНаценки
			|ИЗ
			|	Справочник.СоглашенияСКлиентами КАК СоглашенияСКлиентами
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЦеновыеГруппы КАК СправочникЦеновыеГруппы ПО ИСТИНА
			|ГДЕ
			|	СоглашенияСКлиентами.Ссылка = &СоглашениеСКлиентом
			|	И СправочникЦеновыеГруппы.Ссылка НЕ В (ВЫБРАТЬ Т.ЦеноваяГруппа ИЗ Справочник.СоглашенияСКлиентами.ЦеновыеГруппы КАК Т ГДЕ Т.Ссылка = &СоглашениеСКлиентом И Т.Ссылка.ОграничиватьРучныеСкидки)
			|	И СоглашенияСКлиентами.ОграничиватьРучныеСкидки
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	СоглашенияСКлиентамиЦеновыеГруппы.ЦеноваяГруппа        КАК ЦеноваяГруппа,
			//++Гольм А.А. (Гигабайт)
			// начало доп настройки
			|СоглашенияСКлиентамиЦеновыеГруппы.Деактивирован,
			|ВЫБОР
			|КОГДА ЕСТЬNULL(СоглашенияСКлиентамиЦеновыеГруппы.ПроцентИндивидуальнойСкидкиНаценки, СоглашенияСКлиентамиЦеновыеГруппы.ПроцентРучнойСкидки) > 0
			|		ТОГДА ЕСТЬNULL(СоглашенияСКлиентамиЦеновыеГруппы.ПроцентИндивидуальнойСкидкиНаценки, СоглашенияСКлиентамиЦеновыеГруппы.ПроцентРучнойСкидки)
			|	ИНАЧЕ 0
			|КОНЕЦ  КАК ПроцентРучнойСкидки,
			|ВЫБОР
			|КОГДА ЕСТЬNULL(СоглашенияСКлиентамиЦеновыеГруппы.ПроцентИндивидуальнойСкидкиНаценки, СоглашенияСКлиентамиЦеновыеГруппы.ПроцентРучнойНаценки) < 0
			|		ТОГДА ЕСТЬNULL(СоглашенияСКлиентамиЦеновыеГруппы.ПроцентИндивидуальнойСкидкиНаценки, СоглашенияСКлиентамиЦеновыеГруппы.ПроцентРучнойНаценки)
			|	ИНАЧЕ 0
			|КОНЕЦ КАК ПроцентРучнойНаценки
			// окончание доп настройки
			//--Гольм А.А. (Гигабайт)
			|ИЗ
			|	Справочник.СоглашенияСКлиентами.ЦеновыеГруппы КАК СоглашенияСКлиентамиЦеновыеГруппы
			|ГДЕ
			|	СоглашенияСКлиентамиЦеновыеГруппы.Ссылка = &СоглашениеСКлиентом
			|	И СоглашенияСКлиентамиЦеновыеГруппы.Ссылка.ОграничиватьРучныеСкидки
			|";
			
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
	|;";
	
КонецПроцедуры

Процедура Рин1_СформироватьЗапросВременнаяТаблицаОграниченияРучныхСкидок(ТекстЗапроса, ИспользоватьОграниченияПоСоглашениям = Ложь) Экспорт // добавлен параметр ИспользоватьОграниченияПоСоглашениям
	
	//++Гольм А.А. (Гигабайт) 20.11.2018 10:25:04
	Если ИспользоватьОграниченияПоСоглашениям Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ
		|	ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения.ЦеноваяГруппа,
		|   ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения.Деактивирован КАК Деактивирован,
		|	МИНИМУМ(ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения.ПроцентРучнойНаценки) КАК ПроцентРучнойНаценки,
		|	МИНИМУМ(ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения.ПроцентРучнойСкидки) КАК ПроцентРучнойСкидки
		|ПОМЕСТИТЬ ВременнаяТаблицаОграниченияРучныхСкидок
		|ИЗ
		|	ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения КАК ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения.ЦеноваяГруппа,
		|	ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения.Деактивирован
		|;
		|";
	Иначе
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ
		|	ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения.ЦеноваяГруппа,
		|	МИНИМУМ(ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения.ПроцентРучнойНаценки) КАК ПроцентРучнойНаценки,
		|	МИНИМУМ(ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения.ПроцентРучнойСкидки) КАК ПроцентРучнойСкидки
		|ПОМЕСТИТЬ ВременнаяТаблицаОграниченияРучныхСкидок
		|ИЗ
		|	ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения КАК ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения.ЦеноваяГруппа
		|;
		|";
	КонецЕсли;
	//ТекстЗапроса = ТекстЗапроса + "
	//	|ВЫБРАТЬ
	//	|	ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения.ЦеноваяГруппа,
	//	|	МИНИМУМ(ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения.ПроцентРучнойНаценки) КАК ПроцентРучнойНаценки,
	//	|	МИНИМУМ(ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения.ПроцентРучнойСкидки) КАК ПроцентРучнойСкидки
	//	|ПОМЕСТИТЬ ВременнаяТаблицаОграниченияРучныхСкидок
	//	|ИЗ
	//	|	ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения КАК ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения
	//	|
	//	|СГРУППИРОВАТЬ ПО
	//	|	ВременнаяТаблицаОграничениеРучныхСкидокОбщиеОграничения.ЦеноваяГруппа
	//	|;
	//	|";
	//--Гольм А.А. (Гигабайт) 20.11.2018 10:26:34
	
КонецПроцедуры

Процедура Рин1_СформироватьЗапросОграниченияРучныхСкидокНаценок(ТекстЗапроса, ИспользоватьОграниченияПоСоглашениям = Ложь) //добавлен параметр ИспользоватьОграниченияПоСоглашениям
	
	//++Гольм А.А. (Гигабайт) 20.11.2018 10:27:49
	Если ИспользоватьОграниченияПоСоглашениям Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ
		|	ВременнаяТаблицаОграниченияРучныхСкидок.ЦеноваяГруппа        КАК ЦеноваяГруппа,
		|   ВременнаяТаблицаОграниченияРучныхСкидок.Деактивирован 		 КАК Деактивирован,
		|	ВременнаяТаблицаОграниченияРучныхСкидок.ПроцентРучнойСкидки  КАК МаксимальныйПроцентРучнойСкидки,
		|	ВременнаяТаблицаОграниченияРучныхСкидок.ПроцентРучнойНаценки КАК МаксимальныйПроцентРучнойНаценки
		|ИЗ
		|	ВременнаяТаблицаОграниченияРучныхСкидок КАК ВременнаяТаблицаОграниченияРучныхСкидок
		|";
	Иначе
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ
		|	ВременнаяТаблицаОграниченияРучныхСкидок.ЦеноваяГруппа        КАК ЦеноваяГруппа,
		|	ВременнаяТаблицаОграниченияРучныхСкидок.ПроцентРучнойСкидки  КАК МаксимальныйПроцентРучнойСкидки,
		|	ВременнаяТаблицаОграниченияРучныхСкидок.ПроцентРучнойНаценки КАК МаксимальныйПроцентРучнойНаценки
		|ИЗ
		|	ВременнаяТаблицаОграниченияРучныхСкидок КАК ВременнаяТаблицаОграниченияРучныхСкидок
		|";
	КонецЕсли;
	//ТекстЗапроса = ТекстЗапроса + "
	//	|ВЫБРАТЬ
	//	|	ВременнаяТаблицаОграниченияРучныхСкидок.ЦеноваяГруппа        КАК ЦеноваяГруппа,
	//	|	ВременнаяТаблицаОграниченияРучныхСкидок.ПроцентРучнойСкидки  КАК МаксимальныйПроцентРучнойСкидки,
	//	|	ВременнаяТаблицаОграниченияРучныхСкидок.ПроцентРучнойНаценки КАК МаксимальныйПроцентРучнойНаценки
	//	|ИЗ
	//	|	ВременнаяТаблицаОграниченияРучныхСкидок КАК ВременнаяТаблицаОграниченияРучныхСкидок
	//	|";
	//--Гольм А.А. (Гигабайт) 20.11.2018 10:28:37
	
КонецПроцедуры