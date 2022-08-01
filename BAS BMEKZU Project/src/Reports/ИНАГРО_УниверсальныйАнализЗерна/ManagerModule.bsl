#Область СлужебныеПроцедурыИФункции
	 
Функция ЗаполнитьПользовательскиеНастройкиОтчета(КомпоновщикНастроек,СтруктуруОтбораПараметров,ВложеныйОтчет) Экспорт

    Если ВложеныйОтчет Тогда
        Настройки  = КомпоновщикНастроек.Настройки.Структура[0].Настройки;
    Иначе
        Настройки  = КомпоновщикНастроек.Настройки; 
    КонецЕсли; 
    
    ПользовательскиеНастройки = КомпоновщикНастроек.ПользовательскиеНастройки;
    
    Для Каждого ЭлПараметр  Из СтруктуруОтбораПараметров Цикл
        ЭлементНастройки = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ЭлПараметр.Ключ));
        Если НЕ ЭлементНастройки = Неопределено Тогда
            ЭлементНастройки.Значение = ЭлПараметр.Значение;
            Если ЗначениеЗаполнено(ЭлементНастройки.ИдентификаторПользовательскойНастройки) Тогда
                ПользовательскийПараметр = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ЭлементНастройки.ИдентификаторПользовательскойНастройки);
                Если ТипЗнч(ПользовательскийПараметр) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
                    ПользовательскийПараметр.Значение = ЭлементНастройки.Значение;
                    ПользовательскийПараметр.Использование = Истина;
                КонецЕсли;
            КонецЕсли;              	
        КонецЕсли; 
    КонецЦикла;
    
    Для Каждого ЭлОтбор  Из СтруктуруОтбораПараметров Цикл
        ТекОтбор = Новый ПолеКомпоновкиДанных(ЭлОтбор.Ключ);
        Для Каждого ЭлементНастройки Из Настройки.Отбор.Элементы Цикл
            Если ЭлементНастройки.ЛевоеЗначение = ТекОтбор Тогда 
                ЭлементНастройки.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
                ЭлементНастройки.ПравоеЗначение = ЭлОтбор.Значение;
                ЭлементНастройки.Использование = ЗначениеЗаполнено(ЭлПараметр.Значение);
                Если ЗначениеЗаполнено(ЭлементНастройки.ИдентификаторПользовательскойНастройки) Тогда
                    ПользовательскийПараметр = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ЭлементНастройки.ИдентификаторПользовательскойНастройки);
                    Если ТипЗнч(ПользовательскийПараметр) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
                        ПользовательскийПараметр.ВидСравнения   = ЭлементНастройки.ВидСравнения;
                        ПользовательскийПараметр.ПравоеЗначение = ЭлементНастройки.ПравоеЗначение;
                        Если ЗначениеЗаполнено(ЭлементНастройки.ПравоеЗначение) Тогда
                            ПользовательскийПараметр.Использование  =  Истина;
                        Иначе
                            ПользовательскийПараметр.Использование  = Ложь;
                        КонецЕсли; 
                    КонецЕсли;
                КонецЕсли;
            КонецЕсли;
        КонецЦикла;
        
    КонецЦикла; 	
    
	Возврат ПользовательскиеНастройки;	
    
	
КонецФункции // ()

#КонецОбласти