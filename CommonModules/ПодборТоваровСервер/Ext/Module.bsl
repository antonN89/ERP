﻿
&Вместо("ОбработатьЭлементСпискаПоиска")
Процедура Рин1_ОбработатьЭлементСпискаПоиска(ЭлементСписка, РезультатПоиска)
	
	МетаданныеЭлемента = ЭлементСписка.Метаданные;
	ЗначениеЭлемента = ЭлементСписка.Значение;
	
	//bercut191219
	Если не СтрНайти(Строка(ЗначениеЭлемента),"<Объект не найден>") = 0 Тогда	
		Возврат;
	КонецЕсли;
	//
	
	Если ТипЗнч(МетаданныеЭлемента) = Тип("ОбъектМетаданных") Тогда
		
		Если МетаданныеЭлемента = Метаданные.Справочники.Номенклатура Тогда
			РезультатПоиска.Номенклатура.Добавить(ЗначениеЭлемента);
		ИначеЕсли МетаданныеЭлемента = Метаданные.Справочники.ХарактеристикиНоменклатуры Тогда
			РезультатПоиска.ХарактеристикиНоменклатуры.Добавить(ЗначениеЭлемента);
		ИначеЕсли МетаданныеЭлемента = Метаданные.РегистрыСведений.ШтрихкодыНоменклатуры Тогда
			РезультатПоиска.ШтрихкодыНоменклатуры.Добавить(ЗначениеЭлемента.Штрихкод);
		ИначеЕсли МетаданныеЭлемента = Метаданные.Справочники.НоменклатураКонтрагентов Тогда
			РезультатПоиска.НоменклатураПартнеров.Добавить(ЗначениеЭлемента);
		ИначеЕсли МетаданныеЭлемента = Метаданные.Справочники.ОбщероссийскийКлассификаторПродукции Тогда
			РезультатПоиска.ОКП.Добавить(ЗначениеЭлемента);
		Иначе
			ВызватьИсключение НСтр("ru = 'Неизвестная ошибка';
			|en = 'Unknown error'");
		КонецЕсли;
		
	Иначе
		
		Если МетаданныеЭлемента = "Номенклатура" Тогда
			РезультатПоиска.Номенклатура.Добавить(ЗначениеЭлемента);
		ИначеЕсли МетаданныеЭлемента = "ХарактеристикиНоменклатуры" Тогда
			РезультатПоиска.ХарактеристикиНоменклатуры.Добавить(ЗначениеЭлемента);
		ИначеЕсли МетаданныеЭлемента = "ШтрихкодыНоменклатуры" Тогда
			РезультатПоиска.ШтрихкодыНоменклатуры.Добавить(ЗначениеЭлемента);
		ИначеЕсли МетаданныеЭлемента = "НоменклатураКонтрагентов" Тогда
			РезультатПоиска.НоменклатураПартнеров.Добавить(ЗначениеЭлемента);
		ИначеЕсли МетаданныеЭлемента = "ОбщероссийскийКлассификаторПродукции" Тогда
			РезультатПоиска.ОКП.Добавить(ЗначениеЭлемента);
		Иначе
			ВызватьИсключение НСтр("ru = 'Неизвестная ошибка';
			|en = 'Unknown error'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
