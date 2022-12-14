 
&НаСервере
Процедура УстановитьОтбор(ЭлементыОтбора, ИмяПоля, Значение)
	КоличествоИзменено = 0;
	Для Каждого ЭлементОтбора из ЭлементыОтбора Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля) Тогда
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
				ЭлементОтбора.ПравоеЗначение = Значение;
				ЭлементОтбора.Использование = Истина;
				КоличествоИзменено = КоличествоИзменено + 1;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Если КоличествоИзменено = 0 Тогда
		ЭлементОтбора = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля);
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = Значение;
		ЭлементОтбора.Использование = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыСписковНаСервере()
	УстановитьОтбор(СоответствиеВидовЭлектронныхИУчетныхДокументов.Отбор.Элементы, "ВидЭлектронногоДокумента", Объект.Ссылка);
	УстановитьОтбор(СписокПравилаВыгрузки.Отбор.Элементы, "ВидЭлектронногоДокумента", Объект.Ссылка);
	УстановитьОтбор(Счетчики.Отбор.Элементы, "ВидЭлектронногоДокумента", Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Объект.ТипДокумента) Тогда
		Объект.ТипДокумента = ПредопределенноеЗначение("Перечисление.скEDI_ТипыЭлектронныхДокументов.ПервичныйДокумент");
	КонецЕсли;
	
	Попытка
		СоответствиеВидовЭлектронныхИУчетныхДокументов.АвтоматическоеСохранениеПользовательскихНастроек = Ложь;
		СписокПравилаВыгрузки.АвтоматическоеСохранениеПользовательскихНастроек = Ложь;
		Счетчики.АвтоматическоеСохранениеПользовательскихНастроек = Ложь;
	Исключение
	КонецПопытки;
	
	УстановитьОтборыСписковНаСервере();
	Если ЭтоНалоговыйДокумент(Объект.ТипДокумента) Тогда
		Элементы.ГруппаНастройкиСчетчиков.Видимость = Истина;
		Элементы.ГруппаПроверка.Видимость = Истина;
		Элементы.НалоговыйДокументРежимУточненияПоказателей.Видимость = Истина;
	Иначе
		Элементы.ГруппаНастройкиСчетчиков.Видимость = Ложь;
		Элементы.ГруппаПроверка.Видимость = Ложь;
		Элементы.НалоговыйДокументРежимУточненияПоказателей.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Владелец) Тогда
		Элементы.Владелец.ТолькоПросмотр = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	УстановитьОтборыСписковНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиОткрытьСхемуВыгрузки0(Команда)
	#Если НЕ ТонкийКлиент И НЕ ВебКлиент Тогда
		ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			СтруктураОтбора = Новый Структура("ВидЭлектронногоДокумента, ВидДокумента1С, Приоритет", Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет);											   
			лпСхемаВыгрузки = ПолучитьСхемуПравилВыгрузки(СтруктураОтбора, "Схема0"); 
			Если лпСхемаВыгрузки <> Неопределено Тогда
				СхемаКомпоновкиДанных = лпСхемаВыгрузки.Получить();
			КонецЕсли;
			Если СхемаКомпоновкиДанных = Неопределено Тогда
				СхемаКомпоновкиДанных = СоздатьСхемуКомпановкиДанных();
			КонецЕсли;
			КонструкторСхемы = Новый КонструкторСхемыКомпоновкиДанных;
			КонструкторСхемы.УстановитьСхему(СхемаКомпоновкиДанных);
			КонструкторСхемы.Редактировать(ЭтаФорма);
			РедактируемСхему0 = Истина;
			РедактируемСхему1 = Ложь;
			РедактируемСхему2 = Ложь;
			РедактируемСхему3 = Ложь;
			РедактируемСхему4 = Ложь;
			РедактируемСхему5 = Ложь;
		КонецЕсли;
	#Иначе
		Сообщить("Редактирование схем выгрузки возможно только в режиме ""Толстый клиент""");
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиОткрытьСхемуВыгрузки1(Команда)
	#Если НЕ ТонкийКлиент И НЕ ВебКлиент Тогда
		ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			СтруктураОтбора = Новый Структура("ВидЭлектронногоДокумента, ВидДокумента1С, Приоритет", Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет);											   
			лпСхемаВыгрузки = ПолучитьСхемуПравилВыгрузки(СтруктураОтбора, "Схема1"); 
			Если лпСхемаВыгрузки <> Неопределено Тогда
				СхемаКомпоновкиДанных = лпСхемаВыгрузки.Получить();
			КонецЕсли;
			Если СхемаКомпоновкиДанных = Неопределено Тогда
				СхемаКомпоновкиДанных = СоздатьСхемуКомпановкиДанных();
			КонецЕсли;
			КонструкторСхемы = Новый КонструкторСхемыКомпоновкиДанных;
			КонструкторСхемы.УстановитьСхему(СхемаКомпоновкиДанных);
			КонструкторСхемы.Редактировать(ЭтаФорма);
			РедактируемСхему0 = Ложь;
			РедактируемСхему1 = Истина;			
			РедактируемСхему2 = Ложь;
			РедактируемСхему3 = Ложь;
			РедактируемСхему4 = Ложь;
			РедактируемСхему5 = Ложь;
		КонецЕсли;
	#Иначе
		Сообщить("Редактирование схем выгрузки возможно только в режиме ""Толстый клиент""");
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиОткрытьСхемуВыгрузки2(Команда)
	#Если НЕ ТонкийКлиент И НЕ ВебКлиент Тогда
		ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			СтруктураОтбора = Новый Структура("ВидЭлектронногоДокумента, ВидДокумента1С, Приоритет", Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет);											   
			лпСхемаВыгрузки = ПолучитьСхемуПравилВыгрузки(СтруктураОтбора, "Схема2"); 
			Если лпСхемаВыгрузки <> Неопределено Тогда
				СхемаКомпоновкиДанных = лпСхемаВыгрузки.Получить();
			КонецЕсли;
			Если СхемаКомпоновкиДанных = Неопределено Тогда
				СхемаКомпоновкиДанных = СоздатьСхемуКомпановкиДанных();
			КонецЕсли;
			КонструкторСхемы = Новый КонструкторСхемыКомпоновкиДанных;
			КонструкторСхемы.УстановитьСхему(СхемаКомпоновкиДанных);
			КонструкторСхемы.Редактировать(ЭтаФорма);
			РедактируемСхему0 = Ложь;
			РедактируемСхему1 = Ложь;			
			РедактируемСхему2 = Истина;
			РедактируемСхему3 = Ложь;
			РедактируемСхему4 = Ложь;
			РедактируемСхему5 = Ложь;
		КонецЕсли;
	#Иначе
		Сообщить("Редактирование схем выгрузки возможно только в режиме ""Толстый клиент""");
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиОткрытьСхемуВыгрузки3(Команда)
	#Если НЕ ТонкийКлиент И НЕ ВебКлиент Тогда
		ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			СтруктураОтбора = Новый Структура("ВидЭлектронногоДокумента, ВидДокумента1С, Приоритет", Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет);											   
			лпСхемаВыгрузки = ПолучитьСхемуПравилВыгрузки(СтруктураОтбора, "Схема3"); 
			Если лпСхемаВыгрузки <> Неопределено Тогда
				СхемаКомпоновкиДанных = лпСхемаВыгрузки.Получить();
			КонецЕсли;
			Если СхемаКомпоновкиДанных = Неопределено Тогда
				СхемаКомпоновкиДанных = СоздатьСхемуКомпановкиДанных();
			КонецЕсли;
			КонструкторСхемы = Новый КонструкторСхемыКомпоновкиДанных;
			КонструкторСхемы.УстановитьСхему(СхемаКомпоновкиДанных);
			КонструкторСхемы.Редактировать(ЭтаФорма);
			РедактируемСхему0 = Ложь;
			РедактируемСхему1 = Ложь;			
			РедактируемСхему2 = Ложь;
			РедактируемСхему3 = Истина;
			РедактируемСхему4 = Ложь;
			РедактируемСхему5 = Ложь;
		КонецЕсли;
	#Иначе
		Сообщить("Редактирование схем выгрузки возможно только в режиме ""Толстый клиент""");
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиОткрытьСхемуВыгрузки4(Команда)
	#Если НЕ ТонкийКлиент И НЕ ВебКлиент Тогда
		ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			СтруктураОтбора = Новый Структура("ВидЭлектронногоДокумента, ВидДокумента1С, Приоритет", Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет);											   
			лпСхемаВыгрузки = ПолучитьСхемуПравилВыгрузки(СтруктураОтбора, "Схема4"); 
			Если лпСхемаВыгрузки <> Неопределено Тогда
				СхемаКомпоновкиДанных = лпСхемаВыгрузки.Получить();
			КонецЕсли;
			Если СхемаКомпоновкиДанных = Неопределено Тогда
				СхемаКомпоновкиДанных = СоздатьСхемуКомпановкиДанных();
			КонецЕсли;
			КонструкторСхемы = Новый КонструкторСхемыКомпоновкиДанных;
			КонструкторСхемы.УстановитьСхему(СхемаКомпоновкиДанных);
			КонструкторСхемы.Редактировать(ЭтаФорма);
			РедактируемСхему0 = Ложь;
			РедактируемСхему1 = Ложь;			
			РедактируемСхему2 = Ложь;
			РедактируемСхему3 = Ложь;
			РедактируемСхему4 = Истина;
			РедактируемСхему5 = Ложь;
		КонецЕсли;
	#Иначе
		Сообщить("Редактирование схем выгрузки возможно только в режиме ""Толстый клиент""");
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиОткрытьСхемуВыгрузки5(Команда)
	#Если НЕ ТонкийКлиент И НЕ ВебКлиент Тогда
		ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			СтруктураОтбора = Новый Структура("ВидЭлектронногоДокумента, ВидДокумента1С, Приоритет", Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет);											   
			лпСхемаВыгрузки = ПолучитьСхемуПравилВыгрузки(СтруктураОтбора, "Схема5"); 
			Если лпСхемаВыгрузки <> Неопределено Тогда
				СхемаКомпоновкиДанных = лпСхемаВыгрузки.Получить();
			КонецЕсли;
			Если СхемаКомпоновкиДанных = Неопределено Тогда
				СхемаКомпоновкиДанных = СоздатьСхемуКомпановкиДанных();
			КонецЕсли;
			КонструкторСхемы = Новый КонструкторСхемыКомпоновкиДанных;
			КонструкторСхемы.УстановитьСхему(СхемаКомпоновкиДанных);
			КонструкторСхемы.Редактировать(ЭтаФорма);
			РедактируемСхему0 = Ложь;
			РедактируемСхему1 = Ложь;			
			РедактируемСхему2 = Ложь;
			РедактируемСхему3 = Ложь;
			РедактируемСхему4 = Ложь;
			РедактируемСхему5 = Истина;
		КонецЕсли;
	#Иначе
		Сообщить("Редактирование схем выгрузки возможно только в режиме ""Толстый клиент""");
	#КонецЕсли
КонецПроцедуры

&НаСервере
Функция ПолучитьСхемуПравилВыгрузки(Отбор, Ключ)
	Схема = Неопределено;
	ЗаписьРегистраСведений = РегистрыСведений.скEDI_ПравилаВыгрузки.Получить(Отбор);
	Если ЗаписьРегистраСведений <> Неопределено Тогда
		ЗаписьРегистраСведений.Свойство(Ключ, Схема);
	КонецЕсли;
	Возврат Схема;
КонецФункции

&НаСервере
Функция ПолучитьСхемуXMLПравилВыгрузки(Отбор, Ключ)
	ЗаписьРегистраСведений = РегистрыСведений.скEDI_ПравилаВыгрузки.Получить(Отбор);
	Если ЗаписьРегистраСведений <> Неопределено Тогда
		Схема = Неопределено;
		ЗаписьРегистраСведений.Свойство(Ключ, Схема);
		Если Схема <> Неопределено Тогда
			СхемаКомпоновкиДанных = Схема.Получить();		
			Если СхемаКомпоновкиДанных <> Неопределено Тогда
				ЗаписьXML = Новый ЗаписьXML;
				ЗаписьXML.УстановитьСтроку();
				СериализаторXDTO.ЗаписатьXML(ЗаписьXML, СхемаКомпоновкиДанных);
				СтрокаXML = ЗаписьXML.Закрыть();
				Возврат СтрокаXML;
			Иначе
				Возврат Неопределено;
			КонецЕсли;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

&НаСервере
Функция СоздатьСхемуКомпановкиДанных()
	Возврат Новый СхемаКомпоновкиДанных;
КонецФункции

&НаКлиенте
Процедура ПравилаВыгрузкиОчиститьСхему0(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОчиститьСхемуПравилВыгрузки(Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет, "Схема0");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиОчиститьСхему1(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОчиститьСхемуПравилВыгрузки(Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет, "Схема1");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиОчиститьСхему2(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОчиститьСхемуПравилВыгрузки(Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет, "Схема2");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиОчиститьСхему3(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОчиститьСхемуПравилВыгрузки(Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет, "Схема3");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиОчиститьСхему4(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОчиститьСхемуПравилВыгрузки(Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет, "Схема4");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиОчиститьСхему5(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОчиститьСхемуПравилВыгрузки(Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет, "Схема5");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОчиститьСхемуПравилВыгрузки(ВидЭлектронногоДокумента, ВидДокумента1С, Приоритет, Ключ)
	МенеджерЗаписи = РегистрыСведений.скEDI_ПравилаВыгрузки.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ВидЭлектронногоДокумента = ВидЭлектронногоДокумента;	
	МенеджерЗаписи.ВидДокумента1С 			= ВидДокумента1С;
	МенеджерЗаписи.Приоритет 				= Приоритет;
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда
		Если Ключ = "Схема0" Тогда
			МенеджерЗаписи.Схема0 = Неопределено;
		ИначеЕсли Ключ = "Схема1" Тогда
			МенеджерЗаписи.Схема1 = Неопределено;
		ИначеЕсли Ключ = "Схема2" Тогда
			МенеджерЗаписи.Схема2 = Неопределено;
		ИначеЕсли Ключ = "Схема3" Тогда
			МенеджерЗаписи.Схема3 = Неопределено;
		ИначеЕсли Ключ = "Схема4" Тогда
			МенеджерЗаписи.Схема4 = Неопределено;
		ИначеЕсли Ключ = "Схема5" Тогда
			МенеджерЗаписи.Схема5 = Неопределено;
		КонецЕсли;
		МенеджерЗаписи.Записать(Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьСхемуXMLПравилВыгрузки(ВидЭлектронногоДокумента, ВидДокумента1С, Приоритет, Ключ, СтрокаXML)
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	
	СхемаВыгрузки = СериализаторXDTO.ПрочитатьXML(ЧтениеXML, Тип("СхемаКомпоновкиДанных"));
	
	МенеджерЗаписи = РегистрыСведений.скEDI_ПравилаВыгрузки.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ВидЭлектронногоДокумента = ВидЭлектронногоДокумента;	
	МенеджерЗаписи.ВидДокумента1С 			= ВидДокумента1С;
	МенеджерЗаписи.Приоритет 				= Приоритет;
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда
		Если Ключ = "Схема0" Тогда
			МенеджерЗаписи.Схема0 = Новый ХранилищеЗначения(СхемаВыгрузки);
		ИначеЕсли Ключ = "Схема1" Тогда
			МенеджерЗаписи.Схема1 = Новый ХранилищеЗначения(СхемаВыгрузки);
		ИначеЕсли Ключ = "Схема2" Тогда
			МенеджерЗаписи.Схема2 = Новый ХранилищеЗначения(СхемаВыгрузки);
		ИначеЕсли Ключ = "Схема3" Тогда
			МенеджерЗаписи.Схема3 = Новый ХранилищеЗначения(СхемаВыгрузки);
		ИначеЕсли Ключ = "Схема4" Тогда
			МенеджерЗаписи.Схема4 = Новый ХранилищеЗначения(СхемаВыгрузки);
		ИначеЕсли Ключ = "Схема5" Тогда
			МенеджерЗаписи.Схема5 = Новый ХранилищеЗначения(СхемаВыгрузки);
		КонецЕсли;
		МенеджерЗаписи.Записать(Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиЗагрузитьСхемуВыгрузки0(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Фильтр = НСтр("ru='Файл xml (*.xml)|*.xml';uk='Файл xml (*.xml)|*.xml'");
		Диалог.Фильтр = Фильтр;
		Диалог.МножественныйВыбор = Ложь;
		Диалог.Расширение = "xml";
		Диалог.ПроверятьСуществованиеФайла = Истина;
		Если Диалог.Выбрать() Тогда
			ТД = Новый ТекстовыйДокумент;
			ТД.Прочитать(Диалог.ПолноеИмяФайла);
			СтрокаXML = ТД.ПолучитьТекст();
			ЗаписатьСхемуXMLПравилВыгрузки(Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет, "Схема0", СтрокаXML);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиЗагрузитьСхемуВыгрузки1(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Фильтр = НСтр("ru='Файл xml (*.xml)|*.xml';uk='Файл xml (*.xml)|*.xml'");
		Диалог.Фильтр = Фильтр;
		Диалог.МножественныйВыбор = Ложь;
		Диалог.Расширение = "xml";
		Диалог.ПроверятьСуществованиеФайла = Истина;
		Если Диалог.Выбрать() Тогда
			ТД = Новый ТекстовыйДокумент;
			ТД.Прочитать(Диалог.ПолноеИмяФайла);
			СтрокаXML = ТД.ПолучитьТекст();
			ЗаписатьСхемуXMLПравилВыгрузки(Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет, "Схема1", СтрокаXML);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиЗагрузитьСхемуВыгрузки2(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Фильтр = НСтр("ru='Файл xml (*.xml)|*.xml';uk='Файл xml (*.xml)|*.xml'");
		Диалог.Фильтр = Фильтр;
		Диалог.МножественныйВыбор = Ложь;
		Диалог.Расширение = "xml";
		Диалог.ПроверятьСуществованиеФайла = Истина;
		Если Диалог.Выбрать() Тогда
			ТД = Новый ТекстовыйДокумент;
			ТД.Прочитать(Диалог.ПолноеИмяФайла);
			СтрокаXML = ТД.ПолучитьТекст();
			ЗаписатьСхемуXMLПравилВыгрузки(Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет, "Схема2", СтрокаXML);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиЗагрузитьСхемуВыгрузки3(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Фильтр = НСтр("ru='Файл xml (*.xml)|*.xml';uk='Файл xml (*.xml)|*.xml'");
		Диалог.Фильтр = Фильтр;
		Диалог.МножественныйВыбор = Ложь;
		Диалог.Расширение = "xml";
		Диалог.ПроверятьСуществованиеФайла = Истина;
		Если Диалог.Выбрать() Тогда
			ТД = Новый ТекстовыйДокумент;
			ТД.Прочитать(Диалог.ПолноеИмяФайла);
			СтрокаXML = ТД.ПолучитьТекст();
			ЗаписатьСхемуXMLПравилВыгрузки(Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет, "Схема3", СтрокаXML);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиЗагрузитьСхемуВыгрузки4(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Фильтр = НСтр("ru='Файл xml (*.xml)|*.xml';uk='Файл xml (*.xml)|*.xml'");
		Диалог.Фильтр = Фильтр;
		Диалог.МножественныйВыбор = Ложь;
		Диалог.Расширение = "xml";
		Диалог.ПроверятьСуществованиеФайла = Истина;
		Если Диалог.Выбрать() Тогда
			ТД = Новый ТекстовыйДокумент;
			ТД.Прочитать(Диалог.ПолноеИмяФайла);
			СтрокаXML = ТД.ПолучитьТекст();
			ЗаписатьСхемуXMLПравилВыгрузки(Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет, "Схема4", СтрокаXML);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиЗагрузитьСхемуВыгрузки5(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Фильтр = НСтр("ru='Файл xml (*.xml)|*.xml';uk='Файл xml (*.xml)|*.xml'");
		Диалог.Фильтр = Фильтр;
		Диалог.МножественныйВыбор = Ложь;
		Диалог.Расширение = "xml";
		Диалог.ПроверятьСуществованиеФайла = Истина;
		Если Диалог.Выбрать() Тогда
			ТД = Новый ТекстовыйДокумент;
			ТД.Прочитать(Диалог.ПолноеИмяФайла);
			СтрокаXML = ТД.ПолучитьТекст();
			ЗаписатьСхемуXMLПравилВыгрузки(Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет, "Схема5", СтрокаXML);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиСохранитьСхемуВыгрузки0(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		СтруктураОтбора = Новый Структура("ВидЭлектронногоДокумента, ВидДокумента1С, Приоритет", Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет);											   
		лпСхемаВыгрузкиXML = ПолучитьСхемуXMLПравилВыгрузки(СтруктураОтбора, "Схема0");
		Если лпСхемаВыгрузкиXML = Неопределено Тогда
		Иначе
			Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
			Фильтр = НСтр("ru='Файл xml (*.xml)|*.xml';uk='Файл xml (*.xml)|*.xml'");
			Диалог.Фильтр = Фильтр;
			Диалог.Расширение = "xml";
			Если Диалог.Выбрать() Тогда
				ТД = Новый ТекстовыйДокумент;
				ТД.УстановитьТекст(лпСхемаВыгрузкиXML);
				ТД.Записать(Диалог.ПолноеИмяФайла);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиСохранитьСхемуВыгрузки1(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		СтруктураОтбора = Новый Структура("ВидЭлектронногоДокумента, ВидДокумента1С, Приоритет", Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет);											   
		лпСхемаВыгрузкиXML = ПолучитьСхемуXMLПравилВыгрузки(СтруктураОтбора, "Схема1");
		Если лпСхемаВыгрузкиXML = Неопределено Тогда
		Иначе
			Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
			Фильтр = НСтр("ru='Файл xml (*.xml)|*.xml';uk='Файл xml (*.xml)|*.xml'");
			Диалог.Фильтр = Фильтр;
			Диалог.Расширение = "xml";
			Если Диалог.Выбрать() Тогда
				ТД = Новый ТекстовыйДокумент;
				ТД.УстановитьТекст(лпСхемаВыгрузкиXML);
				ТД.Записать(Диалог.ПолноеИмяФайла);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиСохранитьСхемуВыгрузки2(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		СтруктураОтбора = Новый Структура("ВидЭлектронногоДокумента, ВидДокумента1С, Приоритет", Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет);											   
		лпСхемаВыгрузкиXML = ПолучитьСхемуXMLПравилВыгрузки(СтруктураОтбора, "Схема2");
		Если лпСхемаВыгрузкиXML = Неопределено Тогда
		Иначе
			Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
			Фильтр = НСтр("ru='Файл xml (*.xml)|*.xml';uk='Файл xml (*.xml)|*.xml'");
			Диалог.Фильтр = Фильтр;
			Диалог.Расширение = "xml";
			Если Диалог.Выбрать() Тогда
				ТД = Новый ТекстовыйДокумент;
				ТД.УстановитьТекст(лпСхемаВыгрузкиXML);
				ТД.Записать(Диалог.ПолноеИмяФайла);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиСохранитьСхемуВыгрузки3(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		СтруктураОтбора = Новый Структура("ВидЭлектронногоДокумента, ВидДокумента1С, Приоритет", Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет);											   
		лпСхемаВыгрузкиXML = ПолучитьСхемуXMLПравилВыгрузки(СтруктураОтбора, "Схема3");
		Если лпСхемаВыгрузкиXML = Неопределено Тогда
		Иначе
			Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
			Фильтр = НСтр("ru='Файл xml (*.xml)|*.xml';uk='Файл xml (*.xml)|*.xml'");
			Диалог.Фильтр = Фильтр;
			Диалог.Расширение = "xml";
			Если Диалог.Выбрать() Тогда
				ТД = Новый ТекстовыйДокумент;
				ТД.УстановитьТекст(лпСхемаВыгрузкиXML);
				ТД.Записать(Диалог.ПолноеИмяФайла);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиСохранитьСхемуВыгрузки4(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		СтруктураОтбора = Новый Структура("ВидЭлектронногоДокумента, ВидДокумента1С, Приоритет", Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет);											   
		лпСхемаВыгрузкиXML = ПолучитьСхемуXMLПравилВыгрузки(СтруктураОтбора, "Схема4");
		Если лпСхемаВыгрузкиXML = Неопределено Тогда
		Иначе
			Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
			Фильтр = НСтр("ru='Файл xml (*.xml)|*.xml';uk='Файл xml (*.xml)|*.xml'");
			Диалог.Фильтр = Фильтр;
			Диалог.Расширение = "xml";
			Если Диалог.Выбрать() Тогда
				ТД = Новый ТекстовыйДокумент;
				ТД.УстановитьТекст(лпСхемаВыгрузкиXML);
				ТД.Записать(Диалог.ПолноеИмяФайла);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыгрузкиСохранитьСхемуВыгрузки5(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		СтруктураОтбора = Новый Структура("ВидЭлектронногоДокумента, ВидДокумента1С, Приоритет", Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет);											   
		лпСхемаВыгрузкиXML = ПолучитьСхемуXMLПравилВыгрузки(СтруктураОтбора, "Схема5");
		Если лпСхемаВыгрузкиXML = Неопределено Тогда
		Иначе
			Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
			Фильтр = НСтр("ru='Файл xml (*.xml)|*.xml';uk='Файл xml (*.xml)|*.xml'");
			Диалог.Фильтр = Фильтр;
			Диалог.Расширение = "xml";
			Если Диалог.Выбрать() Тогда
				ТД = Новый ТекстовыйДокумент;
				ТД.УстановитьТекст(лпСхемаВыгрузкиXML);
				ТД.Записать(Диалог.ПолноеИмяФайла);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ТипЗнч(ИсточникВыбора) = Тип("КонструкторСхемыКомпоновкиДанных") Тогда
		ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			ОбработкаВыбораСервер(Объект.Ссылка, ТекущиеДанные.ВидДокумента1С, ТекущиеДанные.Приоритет, ВыбранноеЗначение, ТекущиеДанные.ЭтоПредопределенный);
			Если ТекущиеДанные.ЭтоПредопределенный Тогда
				Если скEDI_ОбщегоНазначения.ЭтоПлатформа82() Тогда
					Предупреждение("Шаблон предопределенный. Внесенные изменения не сохранены");
				Иначе
					скEDI_ОткрытиеФормБезМодальности.ПоказатьПредупреждение_83("Шаблон предопределенный. Внесенные изменения не сохранены");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораСервер(ВидЭлектронногоДокумента, ВидДокумента1С, Приоритет, ВыбранноеЗначение, Предопределенный)
	Если Не Предопределенный Тогда
		МенеджерЗаписи = РегистрыСведений.скEDI_ПравилаВыгрузки.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ВидЭлектронногоДокумента = ВидЭлектронногоДокумента;	
		МенеджерЗаписи.ВидДокумента1С 			= ВидДокумента1С;
		МенеджерЗаписи.Приоритет 				= Приоритет;
		МенеджерЗаписи.Прочитать();
		Если РедактируемСхему0 Тогда
			МенеджерЗаписи.Схема0 = Новый ХранилищеЗначения(ВыбранноеЗначение);
		ИначеЕсли РедактируемСхему1 Тогда
			МенеджерЗаписи.Схема1 = Новый ХранилищеЗначения(ВыбранноеЗначение);
		ИначеЕсли РедактируемСхему2 Тогда
			МенеджерЗаписи.Схема2 = Новый ХранилищеЗначения(ВыбранноеЗначение);
		ИначеЕсли РедактируемСхему3 Тогда
			МенеджерЗаписи.Схема3 = Новый ХранилищеЗначения(ВыбранноеЗначение);
		ИначеЕсли РедактируемСхему4 Тогда
			МенеджерЗаписи.Схема4 = Новый ХранилищеЗначения(ВыбранноеЗначение);
		ИначеЕсли РедактируемСхему5 Тогда
			МенеджерЗаписи.Схема5 = Новый ХранилищеЗначения(ВыбранноеЗначение);
		КонецЕсли;
		МенеджерЗаписи.Записать(Истина);
	КонецЕсли;
	РедактируемСхему0 = Ложь;
	РедактируемСхему1 = Ложь;
	РедактируемСхему2 = Ложь;
	РедактируемСхему3 = Ложь;
	РедактируемСхему4 = Ложь;
	РедактируемСхему5 = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура СписокУсловияДокументов1СПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Сообщить(НСтр("ru = 'Элемент не записан.'; uk = 'Елемент не записано.'"));
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПравилаВыгрузкиПриАктивизацииСтроки(Элемент)
	ТекСтрока = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ТекСтрока.ЭтоПредопределенный Тогда
		Элементы.ПравилаВыгрузкиОткрытьСхемуВыгрузки0.Заголовок = НСтр("ru = 'Просмотр схемы выгрузки 0'; uk = 'Перегляд схеми вивантаження 0'");
		Элементы.ПравилаВыгрузкиОткрытьСхемуВыгрузки1.Заголовок = НСтр("ru = 'Просмотр схемы выгрузки 1'; uk = 'Перегляд схеми вивантаження 1'");
		Элементы.ПравилаВыгрузкиОткрытьСхемуВыгрузки2.Заголовок = НСтр("ru = 'Просмотр схемы выгрузки 2'; uk = 'Перегляд схеми вивантаження 2'");
		Элементы.ПравилаВыгрузкиОткрытьСхемуВыгрузки3.Заголовок = НСтр("ru = 'Просмотр схемы выгрузки 3'; uk = 'Перегляд схеми вивантаження 3'");
		Элементы.ПравилаВыгрузкиОткрытьСхемуВыгрузки4.Заголовок = НСтр("ru = 'Просмотр схемы выгрузки 4'; uk = 'Перегляд схеми вивантаження 4'");
		Элементы.ПравилаВыгрузкиОткрытьСхемуВыгрузки5.Заголовок = НСтр("ru = 'Просмотр схемы выгрузки 5'; uk = 'Перегляд схеми вивантаження 5'");
		Элементы.ПравилаВыгрузкиОчиститьСхему0.Доступность = Ложь;
		Элементы.ПравилаВыгрузкиОчиститьСхему1.Доступность = Ложь;
		Элементы.ПравилаВыгрузкиОчиститьСхему2.Доступность = Ложь;
		Элементы.ПравилаВыгрузкиОчиститьСхему3.Доступность = Ложь;
		Элементы.ПравилаВыгрузкиОчиститьСхему4.Доступность = Ложь;
		Элементы.ПравилаВыгрузкиОчиститьСхему5.Доступность = Ложь;
		Элементы.СписокПравилаВыгрузкиПравилаВыгрузкиЗагрузитьСхемуВыгрузки0.Доступность = Ложь;
		Элементы.СписокПравилаВыгрузкиПравилаВыгрузкиЗагрузитьСхемуВыгрузки1.Доступность = Ложь;
		Элементы.СписокПравилаВыгрузкиПравилаВыгрузкиЗагрузитьСхемуВыгрузки2.Доступность = Ложь;
		Элементы.СписокПравилаВыгрузкиПравилаВыгрузкиЗагрузитьСхемуВыгрузки3.Доступность = Ложь;
		Элементы.СписокПравилаВыгрузкиПравилаВыгрузкиЗагрузитьСхемуВыгрузки4.Доступность = Ложь;
		Элементы.СписокПравилаВыгрузкиПравилаВыгрузкиЗагрузитьСхемуВыгрузки5.Доступность = Ложь;
	Иначе
		Элементы.ПравилаВыгрузкиОткрытьСхемуВыгрузки0.Заголовок = НСтр("ru = 'Редактировать схему выгрузки 0'; uk = 'Редагувати схему вивантаження 0'");
		Элементы.ПравилаВыгрузкиОткрытьСхемуВыгрузки1.Заголовок = НСтр("ru = 'Редактировать схему выгрузки 1'; uk = 'Редагувати схему вивантаження 1'");
		Элементы.ПравилаВыгрузкиОткрытьСхемуВыгрузки2.Заголовок = НСтр("ru = 'Редактировать схему выгрузки 2'; uk = 'Редагувати схему вивантаження 2'");
		Элементы.ПравилаВыгрузкиОткрытьСхемуВыгрузки3.Заголовок = НСтр("ru = 'Редактировать схему выгрузки 3'; uk = 'Редагувати схему вивантаження 3'");
		Элементы.ПравилаВыгрузкиОткрытьСхемуВыгрузки4.Заголовок = НСтр("ru = 'Редактировать схему выгрузки 4'; uk = 'Редагувати схему вивантаження 4'");
		Элементы.ПравилаВыгрузкиОткрытьСхемуВыгрузки5.Заголовок = НСтр("ru = 'Редактировать схему выгрузки 5'; uk = 'Редагувати схему вивантаження 5'");
		Элементы.ПравилаВыгрузкиОчиститьСхему0.Доступность = Истина;
		Элементы.ПравилаВыгрузкиОчиститьСхему1.Доступность = Истина;
		Элементы.ПравилаВыгрузкиОчиститьСхему2.Доступность = Истина;
		Элементы.ПравилаВыгрузкиОчиститьСхему3.Доступность = Истина;
		Элементы.ПравилаВыгрузкиОчиститьСхему4.Доступность = Истина;
		Элементы.ПравилаВыгрузкиОчиститьСхему5.Доступность = Истина;
		Элементы.СписокПравилаВыгрузкиПравилаВыгрузкиЗагрузитьСхемуВыгрузки0.Доступность = Истина;
		Элементы.СписокПравилаВыгрузкиПравилаВыгрузкиЗагрузитьСхемуВыгрузки1.Доступность = Истина;
		Элементы.СписокПравилаВыгрузкиПравилаВыгрузкиЗагрузитьСхемуВыгрузки2.Доступность = Истина;
		Элементы.СписокПравилаВыгрузкиПравилаВыгрузкиЗагрузитьСхемуВыгрузки3.Доступность = Истина;
		Элементы.СписокПравилаВыгрузкиПравилаВыгрузкиЗагрузитьСхемуВыгрузки4.Доступность = Истина;
		Элементы.СписокПравилаВыгрузкиПравилаВыгрузкиЗагрузитьСхемуВыгрузки5.Доступность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
функция ПолучитьИнформациюОПоляхШаблонаНаСервере(ЕДРПОУВладельцаШаблона, ИмяШаблона, ВерсияШаблона)
	лпПараметры = Новый Структура;
	Если ИмяШаблона <> "" Тогда
		лпПараметры.Вставить("CharCode", ИмяШаблона);
	КонецЕсли;
	Если ЕДРПОУВладельцаШаблона <> "" Тогда
		лпПараметры.Вставить("TmplOwnerCode", ЕДРПОУВладельцаШаблона);
	КонецЕсли;
	Если ВерсияШаблона <> "" Тогда
		лпПараметры.Вставить("TmplVersion", ВерсияШаблона);
	КонецЕсли;
//	лпПараметры.Вставить("AllFields", Истина);
	лпПараметры.Вставить("AllFields", Ложь);
	СтруктураТаблицыДокументов = скEDI_КомандыEDIПровайдеру.ПолучитьРезультатКомандыEDIПровайдеру("ptn/getdocrk", лпПараметры);
	
	Результат = "";
	Попытка
		Если ЗначениеЗаполнено(СтруктураТаблицыДокументов.CharCode) Тогда
			Результат = "Код шаблона: " + СтруктураТаблицыДокументов.CharCode;
		КонецЕсли;
	Исключение
	КонецПопытки;
	Попытка
		Если ЗначениеЗаполнено(СтруктураТаблицыДокументов.TmplOwnerCode) Тогда
			Результат = Результат + "
			|ЕДРПОУ Владельца шаблона: " + СтруктураТаблицыДокументов.TmplOwnerCode;
		КонецЕсли;
	Исключение
	КонецПопытки;
	Попытка
		Если ЗначениеЗаполнено(СтруктураТаблицыДокументов.TmplVersion) Тогда
			Результат = Результат + "
			|Версия шаблона: " + СтруктураТаблицыДокументов.TmplVersion;
		КонецЕсли;
	Исключение
	КонецПопытки;
	
	Если ЗначениеЗаполнено(СтруктураТаблицыДокументов.Message) Тогда
		Результат = Результат + "
		|Ошибка: " + СтруктураТаблицыДокументов.Message;
	КонецЕсли;
	
	Попытка
		Для Каждого ТаблицаДокумента Из СтруктураТаблицыДокументов.Tables Цикл
			Результат = Результат + "
			|
			|Таблица № " + Строка(ТаблицаДокумента.Num) + "
			|Внутреннее имя таблицы: " + ТаблицаДокумента.Name + "
			|Наименование таблицы: " + ТаблицаДокумента.Description + "
			|Поля:";
			
			Для Каждого ПолеТаблицыДокумента Из ТаблицаДокумента.Fields Цикл
				Результат = Результат + "
				|" + ПолеТаблицыДокумента.Name + " - " + ПолеТаблицыДокумента.Description + " Тип: " + скEDI_ОбщегоНазначения.ПолучитьНаименованиеТипаДанных(ПолеТаблицыДокумента.DataType);
			КонецЦикла;
		КонецЦикла;
	Исключение
		Результат = "
		|
		|Ошибка получения данных по реквизитам.";
	КонецПопытки;
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ПравилаВыгрузкиИнформацияОПоляхШаблона(Команда)
	ТекущиеДанные = Элементы.СписокПравилаВыгрузки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ВвестиСтроку(ПолучитьИнформациюОПоляхШаблонаНаСервере(ТекущиеДанные.ЕДРПОУВладельцаШаблона, ТекущиеДанные.ИмяШаблона, ТекущиеДанные.ВерсияШаблона), ТекущиеДанные.ИмяШаблона, , Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьНастройкиПоГруппамПодписейНаСервере(ОрганизацияEDI)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	скEDI_ГруппыПодписей.Подпись,
	               |	скEDI_ГруппыПодписей.ГруппаПодписи
	               |ИЗ
	               |	РегистрСведений.скEDI_ГруппыПодписей КАК скEDI_ГруппыПодписей
	               |ГДЕ
	               |	скEDI_ГруппыПодписей.Подпись.Владелец = &ОрганизацияEDI";
	Запрос.УстановитьПараметр("ОрганизацияEDI", ОрганизацияEDI);
	Возврат не Запрос.Выполнить().Пустой();
КонецФункции

&НаСервереБезКонтекста
Функция ПодписиПодписьНачалоВыбораНаСервере(ТекущееЗначение, Организация)
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	скEDI_ГруппыПодписей.Ссылка,
	               |	скEDI_ГруппыПодписей.Наименование
	               |ИЗ
	               |	Справочник.скEDI_ГруппыПодписей КАК скEDI_ГруппыПодписей
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	скEDI_ГруппыПодписей.Код";
	ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
	Пока ВыборкаРезультатаЗапроса.Следующий() Цикл
		ЗапросПоСоставуГруппы = Новый Запрос;
		ЗапросПоСоставуГруппы.Текст = "ВЫБРАТЬ
		                              |	скEDI_ГруппыПодписей.Подпись.Ссылка,
		                              |	скEDI_ГруппыПодписей.Подпись.Наименование КАК Наименование
		                              |ИЗ
		                              |	РегистрСведений.скEDI_ГруппыПодписей КАК скEDI_ГруппыПодписей
		                              |ГДЕ
		                              |	скEDI_ГруппыПодписей.ГруппаПодписи = &ГруппаПодписи
		                              |	И скEDI_ГруппыПодписей.Подпись.Владелец = &Организация
		                              |
		                              |УПОРЯДОЧИТЬ ПО
		                              |	Наименование";
		ЗапросПоСоставуГруппы.УстановитьПараметр("ГруппаПодписи", ВыборкаРезультатаЗапроса.Ссылка);
		ЗапросПоСоставуГруппы.УстановитьПараметр("Организация", Организация);
		КоличествоВГруппе = 0;
		СоставГруппы = "";
		ВыборкаЗапросаПоСоставуГрупппы = ЗапросПоСоставуГруппы.Выполнить().Выбрать();
		Пока ВыборкаЗапросаПоСоставуГрупппы.Следующий() Цикл
			Если СоставГруппы <> "" Тогда
				СоставГруппы = СоставГруппы + "; ";
			КонецЕсли;
			Если КоличествоВГруппе > 3 Тогда
				СоставГруппы = СоставГруппы + "...";
				Прервать;
			КонецЕсли;
			КоличествоВГруппе = КоличествоВГруппе + 1;
			СоставГруппы = СоставГруппы + ВыборкаЗапросаПоСоставуГрупппы.Наименование;
		КонецЦикла;
		Если КоличествоВГруппе = 0 Тогда
			Если ВыборкаРезультатаЗапроса.Ссылка = ТекущееЗначение Тогда
				ДанныеВыбора.Добавить(ВыборкаРезультатаЗапроса.Ссылка, ВыборкаРезультатаЗапроса.Наименование + " (<пусто>)", , БиблиотекаКартинок.скEDI_ГруппаПодписей);
			КонецЕсли;
		Иначе
			ДанныеВыбора.Добавить(ВыборкаРезультатаЗапроса.Ссылка, ВыборкаРезультатаЗапроса.Наименование + " (" + СоставГруппы + ")", , БиблиотекаКартинок.скEDI_ГруппаПодписей);
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	скEDI_Подписи.Ссылка,
	               |	скEDI_Подписи.Наименование КАК Наименование
	               |ИЗ
	               |	Справочник.скEDI_Подписи КАК скEDI_Подписи
	               |ГДЕ
	               |	скEDI_Подписи.Владелец = &Организация
	               |	И скEDI_Подписи.ИспользованиеКлюча = ЗНАЧЕНИЕ(Перечисление.скEDI_ИспользованиеКлючей.Подписание)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Наименование";
	Запрос.УстановитьПараметр("Организация", Организация);
	ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
	Пока ВыборкаРезультатаЗапроса.Следующий() Цикл
		ДанныеВыбора.Добавить(ВыборкаРезультатаЗапроса.Ссылка, ВыборкаРезультатаЗапроса.Наименование, , БиблиотекаКартинок.скEDI_Подпись);
	КонецЦикла;
	
	Возврат ДанныеВыбора;
КонецФункции

&НаКлиенте
Процедура ПодписиПодписьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.Подписи.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = ПодписиПодписьНачалоВыбораНаСервере(ТекущиеДанные.Подпись, Объект.Владелец);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодписиПодписьОткрытие(Элемент, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.Подписи.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Если ТипЗнч(ТекущиеДанные.Подпись) = Тип("СправочникСсылка.скEDI_ГруппыПодписей") Тогда
			Если ЗначениеЗаполнено(ТекущиеДанные.Подпись) Тогда
				СтандартнаяОбработка = Ложь;
				ПараметрыГрупы = Новый Структура;
				ПараметрыГрупы.Вставить("Ключ", ТекущиеДанные.Подпись);
				ПараметрыГрупы.Вставить("Организация", Объект.Владелец);
				Форма = ПолучитьФорму("Справочник.скEDI_ГруппыПодписей.ФормаОбъекта", ПараметрыГрупы, ЭтаФорма);
				//Форма = ТекущиеДанные.Подпись.ПолучитьФорму();
				Форма.Открыть();
				Возврат;
				//ОткрытьФорму(
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоНалоговыйДокумент(ТипДокумента)
	Если ТипДокумента = ПредопределенноеЗначение("Перечисление.скEDI_ТипыЭлектронныхДокументов.НалоговаяНакладная") Тогда
		Возврат Истина;
	ИначеЕсли ТипДокумента = ПредопределенноеЗначение("Перечисление.скEDI_ТипыЭлектронныхДокументов.Приложение2КНалоговойНакладной") Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ТипДокументаПриИзменении(Элемент)
	Если ЭтоНалоговыйДокумент(Объект.ТипДокумента) Тогда
		Элементы.ГруппаНастройкиСчетчиков.Видимость = Истина;
		Элементы.ГруппаПроверка.Видимость = Истина;
		Элементы.НалоговыйДокументРежимУточненияПоказателей.Видимость = Истина;
	Иначе
		Элементы.ГруппаНастройкиСчетчиков.Видимость = Ложь;
		Элементы.ГруппаПроверка.Видимость = Ложь;
		Элементы.НалоговыйДокументРежимУточненияПоказателей.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("скEDI_ИзмененСписокВидовЭлектронныхДокументов", Неопределено);
КонецПроцедуры

