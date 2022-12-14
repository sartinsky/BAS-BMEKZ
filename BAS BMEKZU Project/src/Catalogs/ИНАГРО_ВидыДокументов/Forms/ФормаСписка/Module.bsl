#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТолькоДокументыЭлеватора = Истина;
	
	СписокДокументовККУ = ИНАГРО_ЭлеваторОбновлениеИнформационнойБазы.ПолучитьСписокДокументовККУ();
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ИмяПоМетаданным", СписокДокументовККУ, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);

КонецПроцедуры

&НаКлиенте
Процедура ТолькоДокументыЭлеватораПриИзменении(Элемент)	
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ИмяПоМетаданным", СписокДокументовККУ, ВидСравненияКомпоновкиДанных.ВСписке, , ТолькоДокументыЭлеватора);
	
КонецПроцедуры

#КонецОбласти
