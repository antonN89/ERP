﻿
&НаСервере
Процедура Рин1_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,"Ссылка",Константы.Рин1_ПричинаОтменыПриРазделенииЗаказа.Получить(),ВидСравненияКомпоновкиДанных.НеРавно);
	
КонецПроцедуры
