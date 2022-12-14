#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Дата") И Параметры.Дата <> Неопределено Тогда
		
		ПараметрыУчетаЭлеватора         = ИНАГРО_Элеватор.ПолучитьПараметрыУчетаЭлеватора(Параметры.Дата);
		ВывозДействителенОдинДень       = ПараметрыУчетаЭлеватора.ВывозДействителенОдинДень;
		КонтрольПриказаВБизнесПроцессах = ПараметрыУчетаЭлеватора.КонтрольПриказаВБизнесПроцессах;
		СрокДействияПриказа             = ПараметрыУчетаЭлеватора.СрокДействияПриказа;
		
		Если   (ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ИНАГРО_ТТНВывоз")       
			ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ИНАГРО_ТТНВывозЖД") 
			ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ИНАГРО_Переоформление"))
			И ВывозДействителенОдинДень Тогда 			
					
			ГруппаИ = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(Список.Отбор.Элементы, , ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаИ, "Дата", НачалоДня(Параметры.Дата), ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаИ, "Дата", КонецДня(Параметры.Дата),  ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
			
		ИначеЕсли (ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ИНАГРО_ТТНВывоз")
			   ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ИНАГРО_ТТНВывозЖД")
			   ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ИНАГРО_РеестрТТНВывозЖД") // !!!!! 
			   ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ИНАГРО_Переоформление"))
			   И КонтрольПриказаВБизнесПроцессах И СрокДействияПриказа <> 0 Тогда
			  
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ДатаОкончанияДействияПриказа", НачалоДня(Параметры.Дата), ВидСравненияКомпоновкиДанных.БольшеИлиРавно);						

		Иначе
			
			ГруппаИ = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(Список.Отбор.Элементы, , ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаИ, "Дата", НачалоДня(Параметры.Дата), ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаИ, "Дата", КонецДня(Параметры.Дата),  ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
			
		КонецЕсли;
		
	КонецЕсли; 	
	
КонецПроцедуры

#КонецОбласти
