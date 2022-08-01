
&НаКлиенте
Процедура УстановитьВсеФлажки(Команда)
	
	Для каждого СтрокаРегистра Из СписокРегистров Цикл
		СтрокаРегистра.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеФлажки(Команда)
	
	Для каждого СтрокаРегистра Из СписокРегистров Цикл
		СтрокаРегистра.Пометка = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтандартнуюНастройку(Команда)
	
	Для каждого СтрокаДвижений Из СписокДвижений Цикл
		СтрокаРегистра = СписокРегистров.НайтиПоЗначению(СтрокаДвижений.Значение);
		СтрокаРегистра.Пометка = СтрокаДвижений.Пометка;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНастройку(Команда)
	
	Закрыть(СписокРегистров);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("СписокРегистров") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	СписокРегистров = Параметры.СписокРегистров;
	СписокДвижений  = Параметры.СписокДвижений;
	
КонецПроцедуры
