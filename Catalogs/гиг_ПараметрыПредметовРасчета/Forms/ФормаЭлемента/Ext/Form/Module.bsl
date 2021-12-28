﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ЗначенияПараметра, "Владелец", Объект.Ссылка, ВидСравненияКомпоновкиДанных.Равно, , Истина);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ЗначенияПараметра, "Владелец", Объект.Ссылка, ВидСравненияКомпоновкиДанных.Равно, , Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "СозданиеНовогоЗначенияПараметраПредметаРасчета" Тогда
		Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Режим = РежимДиалогаВопрос.ДаНет;
			Оповещение = Новый ОписаниеОповещения("СозданиеНовогоЗначенияПараметраПредметаРасчета_ПослеЗакрытияВопроса", ЭтотОбъект);
			ПоказатьВопрос(Оповещение, "Перед добавлением значения параметра предмета расчета необходимо записать параметр предмета расчета! Записать?", Режим); 
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СозданиеНовогоЗначенияПараметраПредметаРасчета_ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
    Если Результат = КодВозвратаДиалога.Нет Тогда
        Возврат;
	КонецЕсли;
	Записать();
КонецПроцедуры
