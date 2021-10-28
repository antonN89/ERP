﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		// Заполнение шапки
		ЗаказИнициатор = ДанныеЗаполнения.Ссылка;
		//Заполнение ТЧ
		ЗаполнитьТЧ();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьТЧ() Экспорт 
	
	ТЗ = Товары.Выгрузить();
	ТЗ.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказКлиентаТовары.Номенклатура КАК Номенклатура,
	|	ЗаказКлиентаТовары.Характеристика КАК Характеристика,
	|	ЗаказКлиентаТовары.Количество КАК Количество,
//{{20200118 ГлазуновДВ	
	|	ЗаказКлиентаТовары.Упаковка КАК УпаковкаЗаказ,
//}}20200118 ГлазуновДВ
	|	ЗаказКлиентаТовары.ВариантОбеспечения КАК ВариантОбеспечения,
	|	ЗаказКлиентаТовары.ДатаОтгрузки КАК ДатаОтгрузки,
	|	ЗаказКлиентаТовары.Ссылка КАК Заказ,
	|	ИСТИНА КАК Инициатор,
	|	ЗаказКлиентаТовары.НомерСтроки КАК НомерСтрокиТЧ,
	|	ЗаказКлиентаТовары.Ссылка.Склад КАК Склад
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
	|ГДЕ
	|	ЗаказКлиентаТовары.Ссылка = &Ссылка
	|	И ЗаказКлиентаТовары.Ссылка.Проведен
	|	И (ЗаказКлиентаТовары.ВариантОбеспечения = ЗНАЧЕНИЕ(перечисление.ВариантыОбеспечения.ИзЗаказов)
	|			ИЛИ ЗаказКлиентаТовары.ВариантОбеспечения = ЗНАЧЕНИЕ(перечисление.ВариантыОбеспечения.Требуется))
	|	И НЕ ЗаказКлиентаТовары.Отменено
	|
	|УПОРЯДОЧИТЬ ПО
	|	Заказ,
	|	ДатаОтгрузки";
	
	Запрос.УстановитьПараметр("Ссылка", ЗаказИнициатор);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НовСтрока = ТЗ.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрока,ВыборкаДетальныеЗаписи);
		
		Запрос2 = Новый Запрос;
		Запрос2.Текст = 
		"ВЫБРАТЬ
		|	КлючиАналитикиУчетаНоменклатуры.Ссылка КАК Ссылка,
		|	КлючиАналитикиУчетаНоменклатуры.Номенклатура КАК Номенклатура,
		|	КлючиАналитикиУчетаНоменклатуры.Характеристика КАК Характеристика,
		|	КлючиАналитикиУчетаНоменклатуры.МестоХранения КАК МестоХранения
		|ПОМЕСТИТЬ ВтКлючиАналитики
		|ИЗ
		|	Справочник.Номенклатура КАК СпрНоменклатура
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК КлючиАналитикиУчетаНоменклатуры
		|		ПО (КлючиАналитикиУчетаНоменклатуры.Номенклатура = СпрНоменклатура.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
		|		ПО СпрНоменклатура.ХарактеристикаМногооборотнаяТара = ХарактеристикиНоменклатуры.Ссылка
		|			И (ХарактеристикиНоменклатуры.Ссылка = КлючиАналитикиУчетаНоменклатуры.Характеристика)
		|ГДЕ
		|	КлючиАналитикиУчетаНоменклатуры.МестоХранения = &Склад
		|	И СпрНоменклатура.Ссылка = &Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОбеспечениеЗаказовОстатки.Назначение КАК ОЕМПотребность,
		|	ОбеспечениеЗаказовОстатки.Номенклатура КАК Номенклатура,
		|	ОбеспечениеЗаказовОстатки.Номенклатура.ЕдиницаИзмерения КАК Упаковка,
		|	ВтКлючиАналитики.Характеристика КАК Характеристика,
		|	ЗаказНаВнутреннееПотреблениеТовары.ВариантОбеспечения КАК ВариантОбеспечения,
		|	ЗаказНаВнутреннееПотреблениеТовары.НомерСтроки КАК НомерСтроки,
		|	ЗаказНаВнутреннееПотреблениеТовары.ДатаОтгрузки КАК ДатаОтгрузки,
		|	ЗаказНаВнутреннееПотреблениеТовары.Ссылка КАК Ссылка,
		|	ОбеспечениеЗаказовОстатки.НаличиеПодЗаказОстаток КАК КоличествоДоступно
		|ПОМЕСТИТЬ ВТ_ЗаказНаВнутреннееПотребление
		|ИЗ
		|	РегистрНакопления.ОбеспечениеЗаказов.Остатки(
		|			,
		|			Склад = &Склад
		|				И Назначение.ГИГ_ОЕМПотребность
		|				И Номенклатура = &Номенклатура
		|				И Характеристика = &Характеристика) КАК ОбеспечениеЗаказовОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыОрганизаций.Остатки КАК ТоварыОрганизацийОстатки
		|			ЛЕВОЕ СОЕДИНЕНИЕ ВтКлючиАналитики КАК ВтКлючиАналитики
		|			ПО ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры = ВтКлючиАналитики.Ссылка
		|		ПО ОбеспечениеЗаказовОстатки.Номенклатура = ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Номенклатура
		|			И ОбеспечениеЗаказовОстатки.Назначение = ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Назначение
		|			И ОбеспечениеЗаказовОстатки.Склад = ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.МестоХранения
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаВнутреннееПотребление.Товары КАК ЗаказНаВнутреннееПотреблениеТовары
		|		ПО ОбеспечениеЗаказовОстатки.Назначение.Заказ = ЗаказНаВнутреннееПотреблениеТовары.Ссылка
		|			И ОбеспечениеЗаказовОстатки.Номенклатура = ЗаказНаВнутреннееПотреблениеТовары.Номенклатура
		|			И ОбеспечениеЗаказовОстатки.Характеристика = ЗаказНаВнутреннееПотреблениеТовары.Характеристика
		|			И ОбеспечениеЗаказовОстатки.Склад = ЗаказНаВнутреннееПотреблениеТовары.Ссылка.Склад
		|ГДЕ
		|	ОбеспечениеЗаказовОстатки.Назначение.Заказ ССЫЛКА Документ.ЗаказНаВнутреннееПотребление
		|	И (ЗаказНаВнутреннееПотреблениеТовары.ВариантОбеспечения = ЗНАЧЕНИЕ(перечисление.ВариантыОбеспечения.СоСклада)
		|			ИЛИ ЗаказНаВнутреннееПотреблениеТовары.ВариантОбеспечения = ЗНАЧЕНИЕ(перечисление.ВариантыОбеспечения.Обособленно))
		|	И НЕ ЗаказНаВнутреннееПотреблениеТовары.Отменено
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗаказКлиентаТовары.Номенклатура КАК Номенклатура,
		|	ЗаказКлиентаТовары.Характеристика КАК Характеристика,
		|	ЗаказКлиентаТовары.Количество КАК Количество,
		|	ЗаказКлиентаТовары.ВариантОбеспечения КАК ВариантОбеспечения,
		|	ЗаказКлиентаТовары.ДатаОтгрузки КАК ДатаОтгрузки,
		|	ЗаказКлиентаТовары.Ссылка КАК Заказ,
		|	ЛОЖЬ КАК Инициатор,
		|	ЗаказКлиентаТовары.НомерСтроки КАК НомерСтрокиТЧ
		|ПОМЕСТИТЬ ВТ_ЗаказКлиента
		|ИЗ
		|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКОтгрузке.Остатки КАК ТоварыКОтгрузкеОстатки
		|		ПО ЗаказКлиентаТовары.Ссылка = ТоварыКОтгрузкеОстатки.ДокументОтгрузки
		|			И ЗаказКлиентаТовары.Номенклатура = ТоварыКОтгрузкеОстатки.Номенклатура
		|			И ЗаказКлиентаТовары.Характеристика = ТоварыКОтгрузкеОстатки.Характеристика
		|ГДЕ
		|	ЗаказКлиентаТовары.Ссылка.Проведен
		|	И ЗаказКлиентаТовары.ВариантОбеспечения = ЗНАЧЕНИЕ(перечисление.ВариантыОбеспечения.СоСклада)
		|	И (ТоварыКОтгрузкеОстатки.ВРезервеОстаток > 0
		|			ИЛИ ТоварыКОтгрузкеОстатки.КОтгрузкеОстаток > 0)
		|	И НЕ ЗаказКлиентаТовары.Отменено
		|	И НЕ ЗаказКлиентаТовары.Ссылка = &Ссылка
		|	И ЗаказКлиентаТовары.Номенклатура = &Номенклатура
		|	И ЗаказКлиентаТовары.Характеристика = &Характеристика
		|	И ЗаказКлиентаТовары.Склад = &Склад
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ЗаказКлиента.Номенклатура КАК Номенклатура,
		|	ВТ_ЗаказКлиента.Характеристика КАК Характеристика,
		|	ВТ_ЗаказКлиента.Количество КАК Количество,
		|	ВТ_ЗаказКлиента.ВариантОбеспечения КАК ВариантОбеспечения,
		|	ВТ_ЗаказКлиента.ДатаОтгрузки КАК ДатаОтгрузки,
		|	ВТ_ЗаказКлиента.Заказ КАК Заказ,
		|	ВТ_ЗаказКлиента.Инициатор КАК Инициатор,
		|	ВТ_ЗаказКлиента.НомерСтрокиТЧ КАК НомерСтрокиТЧ
		|ИЗ
		|	ВТ_ЗаказКлиента КАК ВТ_ЗаказКлиента
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВТ_ЗаказНаВнутреннееПотребление.Номенклатура,
		|	ВТ_ЗаказНаВнутреннееПотребление.Характеристика,
		|	ВТ_ЗаказНаВнутреннееПотребление.КоличествоДоступно,
		|	ВТ_ЗаказНаВнутреннееПотребление.ВариантОбеспечения,
		|	ВТ_ЗаказНаВнутреннееПотребление.ДатаОтгрузки,
		|	ВТ_ЗаказНаВнутреннееПотребление.Ссылка,
		|	ЛОЖЬ,
		|	ВТ_ЗаказНаВнутреннееПотребление.НомерСтроки
		|ИЗ
		|	ВТ_ЗаказНаВнутреннееПотребление КАК ВТ_ЗаказНаВнутреннееПотребление
		|
		|УПОРЯДОЧИТЬ ПО
		|	Заказ,
		|	ДатаОтгрузки";
		
		// 140520 нужно брать только количество заказанное, не зависимо от того есть ли поступление на этот товар в текущий день (даже без ордера)
		//|	ТоварыОрганизацийОстатки.КоличествоОстаток КАК КоличествоДоступно
		
		Запрос2.УстановитьПараметр("Номенклатура", ВыборкаДетальныеЗаписи.Номенклатура);
		Запрос2.УстановитьПараметр("Ссылка", ВыборкаДетальныеЗаписи.Заказ);
		Запрос2.УстановитьПараметр("Характеристика", ВыборкаДетальныеЗаписи.Характеристика);
		Запрос2.УстановитьПараметр("Склад", ВыборкаДетальныеЗаписи.Склад);

		РезультатЗапроса2 = Запрос2.Выполнить();
		
		ВыборкаДетальныеЗаписи2 = РезультатЗапроса2.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи2.Следующий() Цикл
			НовСтрока = ТЗ.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрока,ВыборкаДетальныеЗаписи2);
			НовСтрока.Родитель = ВыборкаДетальныеЗаписи.НомерСтрокиТЧ;
		КонецЦикла;
		
	КонецЦикла;
	
	Товары.Загрузить(ТЗ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЭтотОбъект.ОбработкаВыполнена = Ложь;
	
КонецПроцедуры
