﻿
&Вместо("ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента")
Процедура Рин1_ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения)
	
	// + [Rineco], [Киселев А.] [13.12.2021] 
	// Задача: [№ 24811], [#СтатусПеремещений]	
	Попытка
		Если Источник.ДополнительныеСвойства.Свойство("НеПроверятьДатуЗапрета") Тогда
			Возврат;
		КонецЕсли;
	Исключение
	КонецПопытки;
// - [Rineco], [Киселев А.] [13.12.2021]
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Источник.ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ПроверитьДатыЗапретаИзмененияДанных(Источник, Отказ);

КонецПроцедуры

&Вместо("ПроверитьДатуЗапретаИзмененияПередЗаписьюНабораЗаписей")
Процедура Рин1_ПроверитьДатуЗапретаИзмененияПередЗаписьюНабораЗаписей(Источник, Отказ, Замещение)
	
	// + [Rineco], [Киселев А.] [13.12.2021] 
	// Задача: [№ 24811], [#СтатусПеремещений]	
	Попытка
		Если  ТипЗнч(Источник.Отбор.Регистратор.Значение) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
			Возврат;
		КонецЕсли;
	Исключение
	КонецПопытки;
	// - [Rineco], [Киселев А.] [13.12.2021]
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьДатыЗапретаИзмененияДанных(Источник, Отказ, Истина, Замещение);
КонецПроцедуры
