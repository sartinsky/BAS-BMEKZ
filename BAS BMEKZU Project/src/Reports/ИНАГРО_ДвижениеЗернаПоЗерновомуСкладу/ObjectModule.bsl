
#Область СлужебныеПроцедурыИФункции

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)   	 
	
	ИдентификаторУрожайГод = "";
	
	Для каждого Элемент Из КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		  Если ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") И ТипЗнч(Элемент.Значение) = Тип("СправочникСсылка.ИНАГРО_ВидыУрожая") Тогда
		  	   ИдентификаторУрожайГод = Элемент.ИдентификаторПользовательскойНастройки;
		  КонецЕсли; 
	КонецЦикла;   	
	
	УрожайГод = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ИдентификаторУрожайГод);
	
	Если УрожайГод <> Неопределено Тогда
		Если УрожайГод.Использование = Истина Тогда
			
			ПараметрГод = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("УрожайГод"));
			
			Если ПараметрГод <> Неопределено Тогда
				ПараметрГод.Значение = УрожайГод.Значение.Год;
				ПараметрГод.Использование = Истина;
			КонецЕсли;  
			
			ПараметрНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
			
			Если ПараметрНачалоПериода <> Неопределено Тогда
				ПараметрНачалоПериода.Значение = УрожайГод.Значение.ДатаНачала;
				ПараметрНачалоПериода.Использование = Истина;
			КонецЕсли; 	
			
		 КонецЕсли; 
	КонецЕсли; 

	
КонецПроцедуры

#КонецОбласти