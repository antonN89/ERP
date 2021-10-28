﻿
&Вместо("ПредставлениеНоменклатурыДляПечати")
Функция Рин1_ПредставлениеНоменклатурыДляПечати(НаименованиеНоменклатурыДляПечати,
	                                       НаименованиеХарактеристикиДляПечати,
	                                       Упаковка = Неопределено,
	                                       Серия = Неопределено,
	                                       ДополнительныеПараметры = Неопределено)
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = ДополнительныеПараметрыПредставлениеНоменклатурыДляПечати();
	КонецЕсли;
	
	Если ТипЗнч(НаименованиеНоменклатурыДляПечати) <> Тип("Строка") Тогда
		ТекстИсключения = НСтр("ru = 'В функцию НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати не передано наименование номенклатуры для печати.';
		|en = 'Product name for printing is not passed to the НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати function.'");	
		ВызватьИсключение ТекстИсключения;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НаименованиеХарактеристикиДляПечати) 
		И ТипЗнч(НаименованиеХарактеристикиДляПечати) <> Тип("Строка") Тогда
		ТекстИсключения = НСтр("ru = 'В функцию НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати не передано наименование характеристики для печати.';
		|en = 'Characteristic name for printing is not passed to the НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати function.'");	
		ВызватьИсключение ТекстИсключения;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДополнительныеПараметры.Содержание) Тогда
		
		ПредставлениеНоменклатуры = СокрЛП(ДополнительныеПараметры.Содержание);
		
	Иначе
		
		ТекстВСкобках = Новый Массив;
		
		Если ЗначениеЗаполнено(НаименованиеХарактеристикиДляПечати) Тогда
			ТекстВСкобках.Добавить(СокрЛП(НаименованиеХарактеристикиДляПечати));
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Упаковка) Тогда
			ТекстВСкобках.Добавить(СокрЛП(Упаковка));
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Серия) Тогда
			ТекстВСкобках.Добавить(СокрЛП(Серия));
		КонецЕсли;
		//++Шерстюк Ю.Ю. обновление на 2.4.11.106 кто-то закомментировал без подписи
		//Если ЗначениеЗаполнено(ДополнительныеПараметры.ВозвратнаяТара) Тогда
		//	ТекстВСкобках.Добавить(НСтр("ru = 'возвратная тара';
		//								|en = 'reusable package'"));
		//КонецЕсли;
		//--Шерстюк Ю.Ю. 
		Если ЗначениеЗаполнено(ДополнительныеПараметры.КодТНВЭД) Тогда
			ТекстВСкобках.Добавить(НСтр("ru = 'Код ТН ВЭД:';
			|en = 'FEACN code:'")+ Символы.НПП + ДополнительныеПараметры.КодТНВЭД);
		КонецЕсли;
		
		ТекстВСкобкахСтрока = СтрСоединить(ТекстВСкобках, ", ");
		
		Если ЗначениеЗаполнено(ТекстВСкобкахСтрока) Тогда
			ПредставлениеНоменклатуры = НСтр("ru = '%НаименованиеНоменклатурыДляПечати% (%ТекстВСкобках%)';
			|en = '%НаименованиеНоменклатурыДляПечати% (%ТекстВСкобках%)'");
			ПредставлениеНоменклатуры = СтрЗаменить(ПредставлениеНоменклатуры, "%ТекстВСкобках%", СокрЛП(ТекстВСкобкахСтрока));
		Иначе
			ПредставлениеНоменклатуры = НСтр("ru = '%НаименованиеНоменклатурыДляПечати%';
			|en = '%НаименованиеНоменклатурыДляПечати%'");
		КонецЕсли;
		
		ПредставлениеНоменклатуры = СтрЗаменить(ПредставлениеНоменклатуры, "%НаименованиеНоменклатурыДляПечати%", СокрЛП(НаименованиеНоменклатурыДляПечати));
		
	КонецЕсли;
	
	Возврат ПредставлениеНоменклатуры;
	
КонецФункции

&Вместо("ПредставлениеНоменклатуры")
Функция Рин1_ПредставлениеНоменклатуры(Номенклатура, Характеристика, Упаковка, Серия, Назначение)
	//++Шерстюк Ю.Ю. обновление на 2.4.11.106 изменен код кем-то без комментариев
	//СтрПредставление = СокрЛП(Номенклатура); //исходный текст
	Попытка	
		
		// + [Rineco], [Киселев А.Н.] [28.10.2021] 
		// Задача: [№ 21173], [#Ошибка]
		
		// Было:
		//СтрПредставление = "(" + СокрЛП(Номенклатура.Артикул) + ") " + СокрЛП(Номенклатура);
		// Стало:
		Если ТипЗнч(Номенклатура) = Тип("Строка") Тогда
			СтрПредставление = СокрЛП(Номенклатура);
		ИначеЕсли ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
			СтрПредставление = "(" + СокрЛП(Номенклатура.Артикул) + ") " + СокрЛП(Номенклатура);
		КонецЕсли;
		// - [Rineco], [Киселев А.Н.] [28.10.2021]
				
		
	Исключение 
	КонецПопытки;
	//--Шерстюк Ю.Ю.
	Если ЗначениеЗаполнено(Характеристика)Тогда
		СтрПредставление = СтрПредставление + " / " + СокрЛП(Характеристика);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Назначение) Тогда
		СтрПредставление = СтрПредставление + " / " + СокрЛП(Назначение);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Серия) Тогда
		СтрПредставление = СтрПредставление + " / " + СокрЛП(Серия);
	КонецЕсли;
	
	Возврат СтрПредставление;
	
КонецФункции
