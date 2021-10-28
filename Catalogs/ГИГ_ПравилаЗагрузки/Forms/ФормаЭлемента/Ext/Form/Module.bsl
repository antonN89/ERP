﻿////////////////////////////////////////////////////////////////////////////////////////////////////

Процедура НастроитьВидимостьСворачиваемыхГрупп()
	
	НастроитьВидимостьСворачиваемойГруппы("ОсновныеДанные");
	НастроитьВидимостьСворачиваемойГруппы("ЕдиницыИзмерения");
	НастроитьВидимостьСворачиваемойГруппы("Логистика");
	
	НастроитьВидимостьСворачиваемойГруппы("ТарифИЦенообразование");
	НастроитьВидимостьСворачиваемойГруппы("ЦеновыеГруппыИИерархия");
	НастроитьВидимостьСворачиваемойГруппы("ДополнительнаяАналитика");
	
КонецПроцедуры

Процедура НастроитьВидимостьСворачиваемойГруппы(ИмяГруппы)
	
	ЭлементСворачиваяГруппа = Элементы["СворачиваемаяГруппа" + ИмяГруппы];
	Элементы["ГруппаЗаголовок" + ИмяГруппы].Видимость = ЕстьВидимыеЭлементыВГруппе(ЭлементСворачиваяГруппа);
	
КонецПроцедуры

Функция ЕстьВидимыеЭлементыВГруппе(Элемент)
	Для Каждого ПодчиненныйЭлемент Из Элемент.ПодчиненныеЭлементы Цикл
		Если ТипЗнч(ПодчиненныйЭлемент) = Тип("ГруппаФормы") Тогда
			Если ПодчиненныйЭлемент.Видимость 
				И ЕстьВидимыеЭлементыВГруппе(ПодчиненныйЭлемент) Тогда
				Возврат Истина;
			КонецЕсли;
		Иначе
			Если ПодчиненныйЭлемент.Видимость Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
КонецФункции

&НаКлиенте
Процедура СвернутьРазвернутьГруппу(Элемент)
	ИмяГруппыСвернутьРазвернуть = Элемент.Имя;
	ИмяГруппыСвернутьРазвернуть = СтрЗаменить(ИмяГруппыСвернутьРазвернуть, "ДекорацияОткрыть", "");
	ИмяГруппыСвернутьРазвернуть = СтрЗаменить(ИмяГруппыСвернутьРазвернуть, "ДекорацияЗакрыть", "");
	ИмяГруппыСвернутьРазвернуть = СтрЗаменить(ИмяГруппыСвернутьРазвернуть, "ЗаголовокГруппы", "");
	ИзменитьСвернутостьГруппы(ИмяГруппыСвернутьРазвернуть);
	ПодключитьОбработчикОжидания("УстановитьАктивностьПослеСворачиванияРазворачиванияГруппы",0.0001,Истина);
КонецПроцедуры

&НаСервере
Процедура ИзменитьСвернутостьГруппы(ИмяГруппы, Свернуть = Неопределено)
	Элементы["СворачиваемаяГруппа" + ИмяГруппы].Видимость = ?(Свернуть = Неопределено, Не Элементы["СворачиваемаяГруппа" + ИмяГруппы].Видимость, Не Свернуть);
	Элементы["ДекорацияОткрыть" + ИмяГруппы].Видимость = ?(Свернуть = Неопределено, Не Элементы["ДекорацияОткрыть" + ИмяГруппы].Видимость, Свернуть);
	Элементы["ДекорацияЗакрыть" + ИмяГруппы].Видимость = ?(Свернуть = Неопределено, Не Элементы["ДекорацияЗакрыть" + ИмяГруппы].Видимость, Не Свернуть);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьАктивностьПослеСворачиванияРазворачиванияГруппы()
	Если Элементы["ДекорацияОткрыть" + ИмяГруппыСвернутьРазвернуть].Видимость Тогда
		ТекущийЭлемент = Элементы["ДекорацияОткрыть" + ИмяГруппыСвернутьРазвернуть];
	Иначе
		ТекущийЭлемент = Элементы["ДекорацияЗакрыть" + ИмяГруппыСвернутьРазвернуть];
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура РазвернутьСворачиваемуюГруппу(ИмяГруппы)
	ГруппаРодитель  = Элементы[ИмяГруппы].Родитель;
	Если ГруппаРодитель = ЭтаФорма Тогда
		Возврат;
	КонецЕсли;
	ИмяГруппыРодителя =ГруппаРодитель.Имя;
	
	Если СтрНайти(ИмяГруппыРодителя, "СворачиваемаяГруппа") = 0 Тогда
		РазвернутьСворачиваемуюГруппу(ИмяГруппыРодителя);
	Иначе
		ИмяГруппыРодителя = СтрЗаменить(ИмяГруппыРодителя, "СворачиваемаяГруппа", "");
		ИзменитьСвернутостьГруппы(ИмяГруппыРодителя, Ложь);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		СкрытьРаскрытьВсеГруппы(Истина);
КонецПроцедуры

&НаСервере
Процедура СкрытьРаскрытьВсеГруппы(Свернуть = Неопределено)
	
	ИменаСворачиваемыхГрупп = ИменаСворачиваемыхГрупп();
	
	Для Каждого ИмяГруппы из ИменаСворачиваемыхГрупп Цикл
		
		ИзменитьСвернутостьГруппы(ИмяГруппы, Свернуть);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СкрытьРаскрытьВсеОсновныеГруппы(Свернуть = Неопределено)
	
	ИменаСворачиваемыхГрупп = ИменаОсновныхСворачиваемыхГрупп();
	
	Для Каждого ИмяГруппы из ИменаСворачиваемыхГрупп Цикл
		
		ИзменитьСвернутостьГруппы(ИмяГруппы, Свернуть);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ИменаСворачиваемыхГрупп()
	
	ИменаСворачиваемыхГрупп = Новый Массив;
	
	ИменаСворачиваемыхГрупп.Добавить("ОсновныеДанные");
	ИменаСворачиваемыхГрупп.Добавить("ЕдиницыИзмерения");
	ИменаСворачиваемыхГрупп.Добавить("Логистика");
	
	ИменаСворачиваемыхГрупп.Добавить("ТарифИЦенообразование");
	ИменаСворачиваемыхГрупп.Добавить("ЦеновыеГруппыИИерархия");
	ИменаСворачиваемыхГрупп.Добавить("ДополнительнаяАналитика");
	
	Возврат ИменаСворачиваемыхГрупп;
КонецФункции

&НаСервере
Функция ИменаОсновныхСворачиваемыхГрупп()
	
	ИменаСворачиваемыхГрупп = Новый Массив;
	
	ИменаСворачиваемыхГрупп.Добавить("ОсновныеДанные");
	ИменаСворачиваемыхГрупп.Добавить("ЕдиницыИзмерения");
	
	ИменаСворачиваемыхГрупп.Добавить("ТарифИЦенообразование");
	ИменаСворачиваемыхГрупп.Добавить("ЦеновыеГруппыИИерархия");
	
	

	Возврат ИменаСворачиваемыхГрупп;
КонецФункции

&НаКлиенте
Процедура НастройкаВидимостиФормыПриИзменении(Элемент)
	
	Если НастройкаВидимостиФормы = "ПоказатьВсе" Тогда
		РежимВидимостиПоказатьТолькоВажные = Ложь;
		СкрытьРаскрытьВсеГруппы(Ложь);
	ИначеЕсли НастройкаВидимостиФормы = "ПоказатьОсновное" Тогда
		РежимВидимостиПоказатьТолькоВажные = Ложь;
		СкрытьРаскрытьВсеГруппы(Истина);
		СкрытьРаскрытьВсеОсновныеГруппы(Ложь);
	Иначе
		РежимВидимостиПоказатьТолькоВажные = Ложь;
		СкрытьРаскрытьВсеГруппы(Истина);
	КонецЕсли;
	
КонецПроцедуры
