#Область ОбработчикиСобытийФормы
	
 &НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    Если Параметры.Свойство("ИмяКоманды") Тогда
        
        ЗаполнитьЗначенияСвойств(Отчет,Параметры.СтруктураПараметровОтбора);
        
    Иначе
        
        ЗагрузитьЗначенияРеквизитов();
        
    КонецЕсли; 
    
    Если Отчет.ПериодОтчета.ДатаНачала = '00010101' Тогда
        Отчет.ПериодОтчета.ДатаНачала  = (НачалоГода(ТекущаяДата()));
    КонецЕсли;
    
    Если Отчет.ПериодОтчета.ДатаОкончания = '00010101' Тогда
        Отчет.ПериодОтчета.ДатаОкончания  = КонецДня(ТекущаяДата());
    КонецЕсли;
    
    Если НЕ ЗначениеЗаполнено(Отчет.Организация) Тогда
        Отчет.Организация   = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
    КонецЕсли;
    
    Если НЕ ЗначениеЗаполнено(Отчет.ВидФормы) Тогда
        Отчет.ВидФормы = "РеестрДвиженийЗернаПоВладельцам";  	
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
    
    Если НЕ ЗавершениеРаботы Тогда
        СохранитьЗначенияРеквизитов();    	
    КонецЕсли; 
    
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
    
    Если ИмяСобытия =  "СменаОтборовОтчета" Тогда
        ПереформироватьОтчет(Параметр);    
    КонецЕсли;
    
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Отчет.ПериодОтчета.ДатаНачала, Отчет.ПериодОтчета.ДатаОкончания);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыборПериода, , , , ОписаниеОповещения); 
КонецПроцедуры

&НаКлиенте
Процедура НастрокиОтчета(Команда)
    
    ПараметрыОткрытия = Новый Структура("ВидКультуры,ВидХранения,Владелец,Номенклатура,
                                |Организация,ПериодОтчета,ПоказыватьДокументы,Склад,Урожай,УсловноеСписание,ВидФормы");
    
	ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, Отчет);
    
    ЗначенияЗаполнения = Новый Структура("ЗначенияЗаполнения",ПараметрыОткрытия);
    ОткрытьФорму("Отчет.ИНАГРО_Форма37.Форма.ФормаНастроек",ЗначенияЗаполнения,ЭтаФорма);
КонецПроцедуры
	    
&НаКлиенте
Процедура СформироватьУнивАнализЗерна(Команда)
	
	ПользовательскиеНастройки = ВернутьНастройкиКомпоновщика("ИНАГРО_УниверсальныйАнализЗерна","АнализЗернаОборотка","Основной");
    ПараметрыОткрытия = Новый Структура("ПользовательскиеНастройки,СформироватьПриОткрытии,КлючВарианта,ИмяКоманды", ПользовательскиеНастройки,Истина,"Основной","УнивАнализЗерна");
    ОткрытьФорму("Отчет.ИНАГРО_УниверсальныйАнализЗерна.Форма.ФормаОтчета",
                ПараметрыОткрытия);


КонецПроцедуры                                                         

&НаКлиенте
Процедура СформироватьУнивАнализЗернаПоДвижениям(Команда)
	
	ПользовательскиеНастройки = ВернутьНастройкиКомпоновщика("ИНАГРО_УниверсальныйАнализЗерна","АнализЗернаСвод","Вариант1");
    ПараметрыОткрытия = Новый Структура("ПользовательскиеНастройки,СформироватьПриОткрытии,КлючВарианта,ИмяКоманды", ПользовательскиеНастройки,Истина,"Вариант1","ПоДвижениям");
    ОткрытьФорму("Отчет.ИНАГРО_УниверсальныйАнализЗерна.Форма.ФормаОтчета",
                ПараметрыОткрытия);


КонецПроцедуры  

&НаКлиенте
Процедура СформироватьУнивАнализСводПоДвижениюЗачВесе(Команда)
    
    ПользовательскиеНастройки = ВернутьНастройкиКомпоновщика("ИНАГРО_УниверсальныйАнализЗерна","СводПоДвижениюЗачВесе","Вариант2");
    ПараметрыОткрытия = Новый Структура("ПользовательскиеНастройки,СформироватьПриОткрытии,КлючВарианта,ИмяКоманды", ПользовательскиеНастройки,Истина,"Вариант2","СводПоДвижениюЗачВесе");
    ОткрытьФорму("Отчет.ИНАГРО_УниверсальныйАнализЗерна.Форма.ФормаОтчета",
                ПараметрыОткрытия);
    
КонецПроцедуры  

&НаКлиенте
Процедура СформироватьФорма36Сводная(Команда)
    
    СтруктураПараметровОтбора = СформироватьСтруктуруОтбораПараметров("Форма36Сводная");
    Отбор = Новый Структура("СтруктураПараметровОтбора,ИмяКоманды",СтруктураПараметровОтбора,"Форма36Сводная");
    ОткрытьФорму("Отчет.ИНАГРО_Форма36.Форма.ФормаОтчета",Отбор);
    
КонецПроцедуры

&НаКлиенте
Процедура СформироватьФорма36ПоВладельцам(Команда)
   
    СтруктураПараметровОтбора = СформироватьСтруктуруОтбораПараметров("Форма36Общая");
    Отбор = Новый Структура("СтруктураПараметровОтбора,ИмяКоманды",СтруктураПараметровОтбора,"Форма36ПоВладельцу");
    ОткрытьФорму("Отчет.ИНАГРО_Форма36.Форма.ФормаОтчета",Отбор);
    
КонецПроцедуры
   

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Отчет.ПериодОтчета.ДатаНачала     = РезультатВыбора.НачалоПериода;
    Отчет.ПериодОтчета.ДатаОкончания  = РезультатВыбора.КонецПериода;

КонецПроцедуры

&НаСервере
Процедура СохранитьЗначенияРеквизитов()

	Настройки = Новый Структура("ВидКультуры,ВидХранения,Владелец,Номенклатура,
                                |Организация,Период,ПоказыватьДокументы,Склад,Урожай,УсловноеСписание,ВидФормы");
	ЗаполнитьЗначенияСвойств(Настройки, Отчет);
    Пользователь = Пользователи.ТекущийПользователь();
	УстановитьПривилегированныйРежим(Истина);
    ХранилищеОбщихНастроек.Сохранить("Отчет.ИНАГРО_Форма37", "Основной",Настройки,,Пользователь.Наименование);
    УстановитьПривилегированныйРежим(Ложь);

   
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьЗначенияРеквизитов()

	Пользователь = Пользователи.ТекущийПользователь();

	УстановитьПривилегированныйРежим(Истина);
    ЗначениеНастроек = ХранилищеОбщихНастроек.Загрузить("Отчет.ИНАГРО_Форма37","Основной",,Пользователь.Наименование);
    УстановитьПривилегированныйРежим(Ложь);
	Если ТипЗнч(ЗначениеНастроек) = Тип("Структура") Тогда

		ЗаполнитьЗначенияСвойств(Отчет, ЗначениеНастроек);

	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ВернутьНастройкиКомпоновщика(ИмяОтчета,ИмяФормыОтчета,ИмяВариантаОтчета)
        
    ОтчетОбъект                 = Отчеты[ИмяОтчета].Создать();
    НовыйКомпоновщикНастроек    = Новый КомпоновщикНастроекКомпоновкиДанных;
    НовыйКомпоновщикНастроек.ЗагрузитьНастройки(ОтчетОбъект.СхемаКомпоновкиДанных.ВариантыНастроек[ИмяВариантаОтчета].Настройки);
    
    СтруктуруОтбораПараметров   = СформироватьСтруктуруОтбораПараметров(ИмяФормыОтчета);
    ВложеныйОтчет               = НовыйКомпоновщикНастроек.Настройки.Структура.Количество() = 1;
    ПользовательскиеНастройки   = Отчеты.ИНАГРО_УниверсальныйАнализЗерна.ЗаполнитьПользовательскиеНастройкиОтчета(НовыйКомпоновщикНастроек,СтруктуруОтбораПараметров,ВложеныйОтчет);
    
    Возврат ПользовательскиеНастройки;
	
КонецФункции

&НаСервере
Функция СформироватьСтруктуруОтбораПараметров(ИмяФормыОтчета ="")
	
	СтруктуруОтбораПараметров = Новый Структура;	
	
    СтруктуруОтбораПараметров.Вставить("Номенклатура",Отчет.Номенклатура);
    СтруктуруОтбораПараметров.Вставить("ВидХранения",Отчет.ВидХранения);
	СтруктуруОтбораПараметров.Вставить("Склад",Отчет.Склад);
    СтруктуруОтбораПараметров.Вставить("Урожай",Отчет.Урожай);
	СтруктуруОтбораПараметров.Вставить("Владелец",Отчет.Владелец);
    СтруктуруОтбораПараметров.Вставить("ВидКультуры",Отчет.ВидКультуры);
    Если ИмяФормыОтчета = "СводПоДвижениюЗачВесе" 
        ИЛИ ИмяФормыОтчета = "АнализЗернаСвод" 
        ИЛИ ИмяФормыОтчета = "АнализЗернаОборотка" Тогда
        СтруктуруОтбораПараметров.Вставить("ПериодОтчета",Отчет.ПериодОтчета);
    Иначе
        СтруктуруОтбораПараметров.Вставить("НачалоПериода",Отчет.ПериодОтчета.ДатаНачала);
        СтруктуруОтбораПараметров.Вставить("КонецПериода",Отчет.ПериодОтчета.ДатаОкончания);
    КонецЕсли; 
    
    СтруктуруОтбораПараметров.Вставить("Организация",Отчет.Организация);
 
    Возврат СтруктуруОтбораПараметров;
	
КонецФункции

&НаСервере
Процедура ПереформироватьОтчет(СтруктураОтборов)
    
    ЗаполнитьЗначенияСвойств(Отчет,СтруктураОтборов);
    ЭтаФорма.СкомпоноватьРезультат();
    
КонецПроцедуры

&НаКлиенте
Процедура ВидФормыПриИзменении(Элемент)
    Если Отчет.ВидФормы = "Форма37Общая" Тогда
        Отчет.ПоказыватьДокументы = Ложь;  	
    КонецЕсли; 
КонецПроцедуры
	
#КонецОбласти 
