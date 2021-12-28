﻿
Процедура ДобавитьПоляРеквизитовНаСервере()
	
	Элементы.ШапкаСхемыОбеспечения.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	
	Группа = Элементы.Добавить("РеквизитыГигабайт",Тип("ГруппаФормы"),Элементы.ШапкаСхемыОбеспечения);
	Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	Группа.Отображение = ОтображениеОбычнойГруппы.Нет;
	Группа.ОтображатьЗаголовок = Ложь;
	
	Элемент = Элементы.Добавить("ГИГ_СкладПоставщика",Тип("ПолеФормы"),Группа);
	Элемент.ПутьКДанным = "СхемаОбеспечения.ГИГ_СкладПоставщика";
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	
	Элемент = Элементы.Добавить("ГИГ_ЗакупкаСПроизводства",Тип("ПолеФормы"),Группа);
	Элемент.ПутьКДанным = "СхемаОбеспечения.ГИГ_ЗакупкаСПроизводства";
	Элемент.Вид = ВидПоляФормы.ПолеФлажка;
	
	Элемент = Элементы.Добавить("ГИГ_Приоритет",Тип("ПолеФормы"),Группа);
	Элемент.ПутьКДанным = "СхемаОбеспечения.ГИГ_Приоритет";
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	
	Группа2 = Элементы.Добавить("РеквизитыРинэко",Тип("ГруппаФормы"),Элементы.ШапкаСхемыОбеспечения);
	Группа2.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	Группа2.Отображение = ОтображениеОбычнойГруппы.Нет;
	Группа2.ОтображатьЗаголовок = Ложь;

	Элемент = Элементы.Добавить("Рин1_ИсключитьИзЗаполненияОбеспечений",Тип("ПолеФормы"),Группа2);
	Элемент.ПутьКДанным = "СхемаОбеспечения.Рин1_ИсключитьИзЗаполненияОбеспечений";
	Элемент.Вид = ВидПоляФормы.ПолеФлажка;
	
КонецПроцедуры


&НаСервере
Процедура Рин1_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	ДобавитьПоляРеквизитовНаСервере();
	
КонецПроцедуры

