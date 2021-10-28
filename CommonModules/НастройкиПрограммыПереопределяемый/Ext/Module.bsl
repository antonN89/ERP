﻿
&После("НастройкиРаботыСФайламиПриСозданииНаСервере")
Процедура Рин1_НастройкиРаботыСФайламиПриСозданииНаСервере(Форма)
	
	  ДобавленнаяГруппаХраненияКартинок = Форма.Элементы.Добавить("ГруппаХраненияКартинок",Тип("ГруппаФормы"),Форма);
	  ДобавленнаяГруппаХраненияКартинок.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	  ДобавленнаяГруппаХраненияКартинок.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяЕслиВозможно;
	  ДобавленнаяГруппаХраненияКартинок.Заголовок = "Хранение картинок описаний";
	  ДобавленнаяГруппаХраненияКартинок.ШрифтЗаголовка = Новый Шрифт(,11,Истина);
	  
	  ДобавленныйЭлементФормы = Форма.Элементы.Добавить("ПолеПутьХранения",Тип("ПолеФормы"),ДобавленнаяГруппаХраненияКартинок);
	  ДобавленныйЭлементФормы.Вид = ВидПоляФормы.ПолеВвода;
	  //++Шерстюк Ю.Ю.
	  //ДобавленныйЭлементФормы.ПутьКДанным = "НаборКонстант.Рин1_ПутьДляХраненияКартинок";
	  //--
	  ДобавленныйЭлементФормы.УстановитьДействие("ПриИзменении","Рин1_ДобавленныйПриИзменении");
	 	 
КонецПроцедуры
