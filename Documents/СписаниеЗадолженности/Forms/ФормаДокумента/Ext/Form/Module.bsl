﻿// + [Rineco], [Киселев А.] [23.11.2021] 
// Задача: [№ 23289], [#Галочка не выгружать]
&НаСервере
Процедура Рин1_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	Если Параметры.Ключ.Пустая() Тогда
		Объект.РИНЭКО_Выгружать = Ложь;
	КонецЕсли;
КонецПроцедуры
