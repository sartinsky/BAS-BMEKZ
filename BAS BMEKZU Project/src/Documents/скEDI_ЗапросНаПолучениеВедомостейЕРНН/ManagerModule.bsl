
Функция ОбработатьЭлектронныйДокумент_Ссылка(ДокументСсылка, ВыполняемыеОперации, МассивПодписей, МассивПодписейШифрования) Экспорт
	ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
	Возврат ОбработатьЭлектронныйДокумент_Объект(ДокументОбъект, ВыполняемыеОперации, МассивПодписей, МассивПодписейШифрования);
КонецФункции

Функция ОбработатьЭлектронныйДокумент_Объект(ДокументОбъект, ВыполняемыеОперации, ТаблицаПодписей, ТаблицаПодписейШифрования) Экспорт
	
	//Если ВыполняемыеОперации.Найти("Подпись") <> Неопределено 
	//	ИЛИ ВыполняемыеОперации.Найти("ОтправкаВДФС") <> Неопределено
	//	ИЛИ ВыполняемыеОперации.Найти("Проверка") <> Неопределено Тогда 
	//	ЗаполнитьПредставленияИзДанныхЭлектронныхДокументов(ТаблицаДанныхДокументов, ДополнительныеПараметры);	
	//КонецЕсли;	
	Если ВыполняемыеОперации.Найти("Подпись") <> Неопределено Тогда	
		Если ДокументОбъект.Состояние = ПредопределенноеЗначение("Перечисление.скEDI_СостоянияДополнительныхЭлектронныхДокументовДФС.Создан") Тогда
			лНастройкиПодписи = ТаблицаПодписей.Найти(ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.ДопДокументыДФС"), "Подпись");
			Если лНастройкиПодписи = Неопределено Тогда
				//Подпись не настроена
				Возврат НСтр("ru = 'Подпись не настроена'; uk = 'Підпис не налаштовано'");
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДокументОбъект.КтоОформилЗапрос) Тогда
				ДанныеПоФизическомуЛицу = скEDI_НастройкиПодКонфигурацию.ПолучитьДанныеПоФизическомуЛицу(ДокументОбъект.КтоОформилЗапрос);
				КодПоДРФО = ДанныеПоФизическомуЛицу.КодПоДРФО;
				Если КодПоДРФО = "" Тогда
					//ОшибкаПолученияПодписей = ОшибкаПолученияПодписей + НСтр("ru = 'Не указан Код по ДРФО Кто оформил запрос'; uk = 'Не вказано Код по ДРФО Хто оформив запит'");
					Возврат НСтр("ru = 'Не указан Код по ДРФО Кто оформил запрос'; uk = 'Не вказано Код по ДРФО Хто оформив запит'");
				Иначе
					Если КодПоДРФО <> лНастройкиПодписи.ДРФО Тогда
						//ДРФО подписанта не соостветствует оветственному
						Возврат НСтр("ru = 'ДРФО подписанта не соостветствует оветственному'; uk = 'ДРФО підписанта не співпадає з відповідальним'");
					КонецЕсли;
				КонецЕсли;
			Иначе	
				КтоОформилЗапрос = скEDI_НастройкиПодКонфигурацию.ПолучитьФизическоеЛицоПоДРФО(лНастройкиПодписи.ДРФО);
				Если ЗначениеЗаполнено(КтоОформилЗапрос) Тогда
					ДокументОбъект.КтоОформилЗапрос = КтоОформилЗапрос;
				Иначе
					//КтоОформилЗапрос не найден
					Возврат НСтр("ru = 'Для заполнения реквизита ""КтоОформилЗапрос"" в справочниике ""Физические лица"" не найден элемент с кодом по ДРФО'; uk = 'Для заповнення реквізита ""ХтоОформивЗапит"" в довіднику ""Фізичні особи"" не знайдено елемент з кодом за ДРФО'") + " """ + лНастройкиПодписи.ДРФО + """";
				КонецЕсли;
			КонецЕсли;
			
			ПредставлениеЭлектронногоДокументаXML = "";
			ПредставлениеЭлектронногоДокументаPDF = "";
			ИмяФайла = "";
			СообщениеОбОшибке = "";
			Если СформироватьЭлектронныйДокумент(ДокументОбъект, Ложь, ПредставлениеЭлектронногоДокументаXML, ПредставлениеЭлектронногоДокументаPDF, ИмяФайла, СообщениеОбОшибке) Тогда
				
				лПараметрыПодписиДокумента = Новый Структура;
				лПараметрыПодписиДокумента.Вставить("Body",     ПредставлениеЭлектронногоДокументаXML);
				СтрокаПодключенияEDI = Неопределено;
				СерверEDI = Неопределено;
				ПортEDI = Неопределено;
				скEDI_ОбщегоНазначения.ДобавитьПараметрыСекретногоКлюча(лПараметрыПодписиДокумента, лНастройкиПодписи, СтрокаПодключенияEDI, СерверEDI, ПортEDI);
				//лПараметрыПодписиДокумента.Вставить("Cert",     лНастройкиПодписи.ТелоСертификата);
				//лПараметрыПодписиДокумента.Вставить("Key",      лНастройкиПодписи.ТелоСекретногоКлюча);
				//лПараметрыПодписиДокумента.Вставить("Password", лНастройкиПодписи.ПарольСекретногоКлюча);
				
				//КоличествоПовторов = Неопределено;
				//Если ДополнительныеПараметры.Свойство("КоличествоПовторовПриОтказе", КоличествоПовторов) Тогда 
				//	Если КоличествоПовторов < 1 Тогда
				//		КоличествоПовторов = 1;
				//	КонецЕсли;
				//Иначе
					КоличествоПовторов = 1;
				//КонецЕсли;
				
				Пока КоличествоПовторов > 0 Цикл
					лРезультатПодписиДокумента = скEDI_КомандыEDIПровайдеру.ПолучитьРезультатКомандыEDIПровайдеру("gov/sign", лПараметрыПодписиДокумента, , СтрокаПодключенияEDI, СерверEDI, ПортEDI);
					Если лРезультатПодписиДокумента.Code = 0 Тогда
						Прервать;
					//Иначе
					//	Если КоличествоПовторов > 1 Тогда
					//    	ДанныеДокумента.ЕстьЗамечания = Истина;
					//	КонецЕсли;
					//	//ДополнитьЖурналНовойСтрокойЧерезРазделитель(ЖурналОперации, "Ошибка подписи документа: " + лРезультатПодписиДокумента.Message + " (код ошибки: " + лРезультатПодписиДокумента.Code + ")");
					//	ДополнитьЖурналНовойСтрокойЧерезРазделитель(ЖурналОперации, "Ошибка подписи документа: " + лРезультатПодписиДокумента.Message);
					КонецЕсли;
					КоличествоПовторов = КоличествоПовторов - 1;
				КонецЦикла;

				Если лРезультатПодписиДокумента.Code <> 0 Тогда
					//ДанныеДокумента.ЕстьОшибки = Истина;
					//
					//Замечание = НСтр("ru = 'Ошибка подписи документа:'; uk = 'Помилка підпису документа:'") + " " + лРезультатПодписиДокумента.Message;
					//ДополнитьЖурналНовойСтрокойЧерезРазделитель(ЖурналОперации, Замечание);
					//
					//ОписаниеОшибок = ДанныеДокумента.ОписаниеОшибок;
					//ДополнитьЖурналНовойСтрокойЧерезРазделитель(ОписаниеОшибок, Замечание);
					//ДанныеДокумента.ОписаниеОшибок = ОписаниеОшибок;
					
					Возврат НСтр("ru = 'Ошибка подписи документа'; uk = 'Помилка підпису документа'") + ":" + " " + лРезультатПодписиДокумента.Message;//Ложь;
				ИначеЕсли ЗначениеЗаполнено(лРезультатПодписиДокумента.Body) Тогда
					ПредставлениеЭлектронногоДокументаXML = лРезультатПодписиДокумента.Body;
				Иначе
					// Ошибка подписания. Нет тела
					Возврат "Ошибка подписания. Нет тела";//Ложь;
				КонецЕсли;
				
				ДокументОбъект.Состояние = ПредопределенноеЗначение("Перечисление.скEDI_СостоянияДополнительныхЭлектронныхДокументовДФС.Подписан");
				ДокументОбъект.ИмяФайлаДФС = ИмяФайла;
				
				ДокументОбъект.Подписи.Очистить();
				НоваяСтрокаПодписи = ДокументОбъект.Подписи.Добавить();
				НоваяСтрокаПодписи.Подпись = лНастройкиПодписи.ВыбранаяПодпись;
				НоваяСтрокаПодписи.Подписано = Истина;
				НоваяСтрокаПодписи.ДатаПодписания = ТекущаяДата();
				
				ДокументОбъект.Записать();
				
				скEDI_ВнешниеХранилища.СохранитьСодержимоеДополнительногоЭлектронногоДокументаДФС(ДокументОбъект.Ссылка, Перечисления.скEDI_ТипыСодержимогоДополнительныхЭлектронныхДокуметовДФС.Запрос, ПредставлениеЭлектронногоДокументаXML, ПредставлениеЭлектронногоДокументаPDF, ТекущаяДата());
				//СодержимоеЭлектронныхДокументовМенеджерЗаписи = РегистрыСведений.скEDI_СодержимоеДополнительныхЭлектронныхДокументовДФС.СоздатьМенеджерЗаписи();
				//СодержимоеЭлектронныхДокументовМенеджерЗаписи.ЭлектронныйДокумент = ДокументОбъект.Ссылка;
				//СодержимоеЭлектронныхДокументовМенеджерЗаписи.ТипСодержимого = Перечисления.скEDI_ТипыСодержимогоДополнительныхЭлектронныхДокуметовДФС.Запрос;
				//СодержимоеЭлектронныхДокументовМенеджерЗаписи.ТелоДокумента = ПредставлениеЭлектронногоДокументаXML;
				//СодержимоеЭлектронныхДокументовМенеджерЗаписи.ИзображениеДокумента = ПредставлениеЭлектронногоДокументаPDF;
				//СодержимоеЭлектронныхДокументовМенеджерЗаписи.Дата = ТекущаяДата();
				//СодержимоеЭлектронныхДокументовМенеджерЗаписи.Записать(Истина);
			Иначе
				Возврат СообщениеОбОшибке;
			КонецЕсли;
			
		//ИначеЕсли ДокументОбъект.Состояние = ПредопределенноеЗначение("Перечисление.скEDI_СостоянияДополнительныхЭлектронныхДокументовДФС.Подписан") Тогда
			
		КонецЕсли;
	КонецЕсли;

	
	Если ВыполняемыеОперации.Найти("ОтправкаВДФС") <> Неопределено Тогда 
		Если ДокументОбъект.Состояние = ПредопределенноеЗначение("Перечисление.скEDI_СостоянияДополнительныхЭлектронныхДокументовДФС.Подписан") Тогда
			ОшибкаПолученияСодержимогоЭлДок = "";
			СодержаниеЭлектронногоДокумента = скEDI_ОбщегоНазначения.ПолучитьСодержаниеДополнительногоЭлектронногоДокументаДФС(ДокументОбъект.Ссылка, ПредопределенноеЗначение("Перечисление.скEDI_ТипыСодержимогоДополнительныхЭлектронныхДокуметовДФС.Запрос"), ОшибкаПолученияСодержимогоЭлДок);
			Если СодержаниеЭлектронногоДокумента = Неопределено Тогда
				Если ОшибкаПолученияСодержимогоЭлДок = "" Тогда
					ОшибкаПолученияСодержимогоЭлДок = НСтр("ru = 'Нет содержимого Электронного документа.'; uk = 'Нема вмісту Електронного документу.'");
				КонецЕсли;
				Возврат ОшибкаПолученияСодержимогоЭлДок;
			КонецЕсли;
			ПредставлениеЭлектронногоДокументаXML = СодержаниеЭлектронногоДокумента.ТелоДокумента;
			
			ОрганизацияEDI = ДокументОбъект.ОрганизацияEDI;
			лНастройкиПодписиШифрования = ТаблицаПодписейШифрования.Найти(ОрганизацияEDI, "ОрганизацияEDI");
	
			Если лНастройкиПодписиШифрования = Неопределено Тогда		
				//ДополнитьЖурналНовойСтрокойЧерезРазделитель(ЖурналОперации, "Не найдены настройки подписи шифрования организации " + лОрганизацияEDI + ".");
				//ДанныеДокумента.ЕстьОшибки = Истина;			
				Возврат "";
			Иначе
				лПараметрыОтправкиДокумента = Новый Структура;
				лПараметрыОтправкиДокумента.Вставить("Body", ПредставлениеЭлектронногоДокументаXML);
				лПараметрыОтправкиДокумента.Вставить("Edrpou", ОрганизацияEDI.Код);
				СтрокаПодключенияEDI = Неопределено;
				СерверEDI = Неопределено;
				ПортEDI = Неопределено;
				скEDI_ОбщегоНазначения.ДобавитьПараметрыСекретногоКлюча(лПараметрыОтправкиДокумента, лНастройкиПодписиШифрования, СтрокаПодключенияEDI, СерверEDI, ПортEDI);
				//лПараметрыОтправкиДокумента.Вставить("Cert", лНастройкиПодписиШифрования.ТелоСертификата);
				//лПараметрыОтправкиДокумента.Вставить("Key", лНастройкиПодписиШифрования.ТелоСекретногоКлюча);
				//лПараметрыОтправкиДокумента.Вставить("Password",  лНастройкиПодписиШифрования.ПарольСекретногоКлюча);
				лПараметрыОтправкиДокумента.Вставить("Email", ОрганизацияEDI.АдресЭлектроннойПочты);

				лРезультатОтправкиДокумента = скEDI_КомандыEDIПровайдеру.ПолучитьРезультатКомандыEDIПровайдеру("gov/send", лПараметрыОтправкиДокумента, , СтрокаПодключенияEDI, СерверEDI, ПортEDI);
				Если лРезультатОтправкиДокумента.Code <> 0 Тогда
					Замечание = НСтр("ru = 'Ошибка отправки документа:'; uk = 'Помилка відправки документа:'") + лРезультатОтправкиДокумента.Message;
					//ДополнитьЖурналНовойСтрокойЧерезРазделитель(ЖурналОперации, Замечание);
					//
					//ОписаниеОшибок = ДанныеДокумента.ОписаниеОшибок;
					//ДополнитьЖурналНовойСтрокойЧерезРазделитель(ОписаниеОшибок, Замечание);
					//ДанныеДокумента.ОписаниеОшибок = ОписаниеОшибок;
					
					Возврат Замечание;
				ИначеЕсли ЗначениеЗаполнено(лРезультатОтправкиДокумента.FileName) Тогда
					лИмяФайла = лРезультатОтправкиДокумента.FileName;
				Иначе
					//Замечание = НСтр("ru = 'В результате отправки не получено имя файла отправленного документа на сервере ГФС.'; uk = 'В результаті відправки не отримано им''я файла відправленного документа на сервері ДФС.'");
					//ДополнитьЖурналНовойСтрокойЧерезРазделитель(ЖурналОперации, Замечание);
					//
					//ОписаниеОшибок = ДанныеДокумента.ОписаниеОшибок;
					//ДополнитьЖурналНовойСтрокойЧерезРазделитель(ОписаниеОшибок, Замечание);
					//ДанныеДокумента.ОписаниеОшибок = ОписаниеОшибок;
					
					Возврат "";
				КонецЕсли;
				
				ДокументОбъект.ИмяФайлаДФС = лИмяФайла;
				ДокументОбъект.Состояние = ПредопределенноеЗначение("Перечисление.скEDI_СостоянияДополнительныхЭлектронныхДокументовДФС.ОтправленВДФС");
				ДокументОбъект.ДатаОтправки = ТекущаяДата();
				ДокументОбъект.Записать();
				//// Зафиксировать событие отправки электронного документа.
				ДатаОтправки = ТекущаяДата();
				лОписаниеПоОтправке = "Відправлено
				|Дата та час відправки: " + Формат(ДатаОтправки, "ДФ='dd.MM.yyyy hh:mm:ss'") + "
				|Одержувач: ДПС
				|Ім'я файлу: " + лИмяФайла;
				Сообщить(лОписаниеПоОтправке);
				//ЗафиксироватьСобытиеЭлектронногоДокумента(ДанныеДокумента.ЭлектронныйДокумент, Перечисления.скEDI_СобытияЭлектронныхДокументов.ОтправкаВДФС, лОписаниеПоОтправке, ДатаОтправки);
				//	
				//УстановитьСнятьОтметкуОбработано(ДанныеДокумента.ЭлектронныйДокумент, Истина);
				//
				//СобытиеДляЖурнала = НСтр("ru = 'Документ отправлен в ГФС'; uk = 'Документ відправлено до ДФС'") + ": """
				//+ лЭлектронныйДокументОбъект.ВидЭлектронногоДокумента.Наименование + """ №" + лЭлектронныйДокументОбъект.НомерДокумента + НСтр("ru = ' от '; uk = ' від '") + Формат(лЭлектронныйДокументОбъект.ДатаДокумента, "ДФ=dd.MM.yyyy");
				//ДополнитьЖурналНовойСтрокойЧерезРазделитель(ЖурналОперации, СобытиеДляЖурнала, , Ложь);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;	
	
КонецФункции

Функция ПолучитьСписокПодписантов(ВыполняемыеОперации, ОрганизацияEDI, Состояние = Неопределено, КтоОформилЗапрос = Неопределено, ОшибкаПолученияПодписей) Экспорт
	Результат = Новый Структура("МассивПодписей,МассивПодписейШифрования");
	ОшибкаПолученияПодписей = "";
	
	Если Не ЗначениеЗаполнено(Состояние) Тогда
		Состояние = ПредопределенноеЗначение("Перечисление.скEDI_СостоянияДополнительныхЭлектронныхДокументовДФС.Создан");
	КонецЕсли;
	
	ПолучатьНедостающиеПодписи = Ложь;
	ПолучатьПодписиШифрования = Ложь;
	
	Для Каждого ВыполняемаяОперация Из ВыполняемыеОперации Цикл
		Если ВыполняемаяОперация = "Подпись" Тогда
			ПолучатьНедостающиеПодписи = Истина;
		ИначеЕсли ВыполняемаяОперация = "ОтправкаВДФС" Тогда
			ПолучатьНедостающиеПодписи = Истина;
			ПолучатьПодписиШифрования = Истина;
		КонецЕсли; 
	КонецЦикла;
	
	Результат.МассивПодписей = Новый Массив;
	Если ПолучатьНедостающиеПодписи Тогда
		Если Состояние = ПредопределенноеЗначение("Перечисление.скEDI_СостоянияДополнительныхЭлектронныхДокументовДФС.Создан") Тогда
			ГруппаПодписей = ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.ДопДокументыДФС");
			Если ЗначениеЗаполнено(КтоОформилЗапрос) Тогда
				ДанныеПоФизическомуЛицу = скEDI_НастройкиПодКонфигурацию.ПолучитьДанныеПоФизическомуЛицу(КтоОформилЗапрос);
				КодПоДРФО = ДанныеПоФизическомуЛицу.КодПоДРФО;
				Если КодПоДРФО = "" Тогда
					Если ЗначениеЗаполнено(ОшибкаПолученияПодписей) Тогда
						ОшибкаПолученияПодписей = ОшибкаПолученияПодписей + Символы.ПС;
					КонецЕсли;
					ОшибкаПолученияПодписей = ОшибкаПолученияПодписей + НСтр("ru = 'Не указан Код по ДРФО Кто оформил запрос'; uk = 'Не вказано Код по ДРФО Хто оформив запит'");
				Иначе
					ТекПодпись = скEDI_ОбщегоНазначения.ПолучитьПодписьИзГруппыПоКодуДРФО(ОрганизацияEDI, ГруппаПодписей, КодПоДРФО);
					Если ТекПодпись = Неопределено Тогда
						Сообщение = НСтр("ru = 'В Группе подписей'; uk = 'В Групі підписів'") + " """ + Строка(ГруппаПодписей) + """ " + НСтр("ru = 'не найдена Подпись с Кодом по ДРФО'; uk = 'не знайдено Підпис з Кодом по ДРФО'") + ": " + КодПоДРФО;
						Если ЗначениеЗаполнено(ОшибкаПолученияПодписей) Тогда
							ОшибкаПолученияПодписей = ОшибкаПолученияПодписей + Символы.ПС;
						КонецЕсли;
						ОшибкаПолученияПодписей = ОшибкаПолученияПодписей + Сообщение;
					Иначе
						Результат.МассивПодписей.Добавить(ТекПодпись);
					КонецЕсли;
				КонецЕсли;
			Иначе
				Результат.МассивПодписей.Добавить(ГруппаПодписей);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Результат.МассивПодписейШифрования = Новый Массив;
	Если ПолучатьПодписиШифрования Тогда
		Если Состояние = ПредопределенноеЗначение("Перечисление.скEDI_СостоянияДополнительныхЭлектронныхДокументовДФС.Создан")
			или	Состояние = ПредопределенноеЗначение("Перечисление.скEDI_СостоянияДополнительныхЭлектронныхДокументовДФС.Подписан") Тогда
			
			лЭлементМассива = Новый Структура;
			лЭлементМассива.Вставить("ПодписьШифрования", Неопределено);
			лЭлементМассива.Вставить("Организация", ОрганизацияEDI);
			Результат.МассивПодписейШифрования.Добавить(лЭлементМассива);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ПолучитьСписокПодписантовДляЭлектронногоДокумента(ВыполняемыеОперации, ДокументОбьектСсылка, ОшибкаПолученияПодписей) Экспорт
	ОрганизацияEDI = ДокументОбьектСсылка.ОрганизацияEDI;
	КтоОформилЗапрос = ДокументОбьектСсылка.КтоОформилЗапрос;
	Состояние = ДокументОбьектСсылка.Состояние;
	
	Возврат ПолучитьСписокПодписантов(ВыполняемыеОперации, ОрганизацияEDI, Состояние, КтоОформилЗапрос, ОшибкаПолученияПодписей);
КонецФункции

Функция УдалитьЛидирующиеНули(Знач ВхСтрока)
	ВхСтрока = СокрЛП(ВхСтрока);
	Пока Лев(ВхСтрока, 1) = "0" и СтрДлина(ВхСтрока) > 1 Цикл
		ВхСтрока = Сред(ВхСтрока, 2);
	КонецЦикла;
	Возврат ВхСтрока;
КонецФункции

Функция ПолучитьМассивДанныхДляЭлектронногоДокумента(ДокументОбьектСсылка, ЭтоТест, КодШаблона, СоответствиеЗначений, СообщениеОбОшибке) Экспорт
	ОрганизацияEDI = ДокументОбьектСсылка.ОрганизацияEDI;
	Если не скEDI_НалоговыеДокументы.ПолучитьАктуальныйКодНалоговогоДокумента(Перечисления.скEDI_ТипыДокументовMEDoc.Т10200, ОрганизацияEDI.ЮрФизЛицо, КодШаблона, "", СообщениеОбОшибке) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	//Если ОрганизацияEDI.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.скEDI_ЮрФизЛицо.ЮрЛицо") Тогда
	//	КодШаблона = "J1300104";
	//ИначеЕсли ОрганизацияEDI.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.скEDI_ЮрФизЛицо.ФизЛицо") Тогда
	//	КодШаблона = "F1300104";
	//Иначе
	//	Возврат Ложь;
	//КонецЕсли;
	
	СоответствиеТаблица0 = Новый Соответствие;
		
	СоответствиеТаблица0.Вставить("HFILL", Формат(ДокументОбьектСсылка.Дата, "ДФ='ddMMyyyy'"));
	СоответствиеТаблица0.Вставить("PERIOD_TYPE", "1");
	//СоответствиеТаблица0.Вставить("HNUM", ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ДокументОбьектСсылка.Номер, Истина, Истина));
	Номер = ДокументОбьектСсылка.Номер;
	// удаление ведущих нулей
	Пока Лев(Номер, 1)="0" Цикл
		Номер = Сред(Номер, 2);
	КонецЦикла;
	СоответствиеТаблица0.Вставить("HNUM", Номер);
	
	СоответствиеТаблица0.Вставить("C_DOC", Сред(КодШаблона, 1, 3));
	СоответствиеТаблица0.Вставить("C_DOC_SUB", Сред(КодШаблона, 4, 3));
	СоответствиеТаблица0.Вставить("C_DOC_VER", Число(Сред(КодШаблона, 7, 2)));
	
	СоответствиеТаблица0.Вставить("C_DOC_TYPE", "0");
	СоответствиеТаблица0.Вставить("C_DOC_STAN", "1");
	СоответствиеТаблица0.Вставить("PERIOD_MONTH", МЕСЯЦ(ДокументОбьектСсылка.Дата));
	СоответствиеТаблица0.Вставить("PERIOD_YEAR", ГОД(ДокументОбьектСсылка.Дата));
	Если ЭтоТест Тогда
		СоответствиеТаблица0.Вставить("C_DOC_CNT", 1);
	Иначе
		СоответствиеТаблица0.Вставить("C_DOC_CNT", скEDI_ОбщегоНазначения.ПолучитьНомерДокументаВПериодеДопДФС(ОрганизацияEDI, ПредопределенноеЗначение("Перечисление.скEDI_ТипыДополнительныхЭлектронныхДокументовДФС.ЗапросНаПолучениеВедомостейЕРНН"), ДокументОбьектСсылка.Дата));
	КонецЕсли;
	СоответствиеТаблица0.Вставить("HTIN", ДокументОбьектСсылка.ОрганизацияEDI.Код);
	СоответствиеТаблица0.Вставить("TIN", ДокументОбьектСсылка.ОрганизацияEDI.Код);
	СоответствиеТаблица0.Вставить("LINKED_DOCS", Null);
	СоответствиеТаблица0.Вставить("D_FILL", Формат(ТекущаяДата(), "ДФ='ddMMyyyy'"));
		
	ДанныеПоОрганизаци = скEDI_НастройкиПодКонфигурацию.ПолучитьДанныеПоОгранизации(ДокументОбьектСсылка.Организация);
	СоответствиеТаблица0.Вставить("C_STI_ORIG", УдалитьЛидирующиеНули(ДанныеПоОрганизаци.НалоговаяИнспекцияКод));
	СоответствиеТаблица0.Вставить("HNPDV", ДанныеПоОрганизаци.ИНН);
	СоответствиеТаблица0.Вставить("HSTI", ДанныеПоОрганизаци.НалоговаяИнспекцияНаименование);
	СоответствиеТаблица0.Вставить("HKSTI", УдалитьЛидирующиеНули(ДанныеПоОрганизаци.НалоговаяИнспекцияКод));
	СоответствиеТаблица0.Вставить("C_REG", УдалитьЛидирующиеНули(ДанныеПоОрганизаци.НалоговаяИнспекцияРегион));
	СоответствиеТаблица0.Вставить("C_RAJ", УдалитьЛидирующиеНули(ДанныеПоОрганизаци.НалоговаяИнспекцияРайон));
	
	СоответствиеТаблица0.Вставить("HNAME", ДокументОбьектСсылка.Организация.НаименованиеПолное);
	
	ДанныеПоФизическомуЛицу = скEDI_НастройкиПодКонфигурацию.ПолучитьДанныеПоФизическомуЛицу(ДокументОбьектСсылка.КтоОформилЗапрос);
	СоответствиеТаблица0.Вставить("HKBOS", ДанныеПоФизическомуЛицу.КодПоДРФО);
	СоответствиеТаблица0.Вставить("HBOS", ДанныеПоФизическомуЛицу.ФИО);
	
	СоответствиеТаблица0.Вставить("HEMAIL", ДокументОбьектСсылка.ОрганизацияEDI.АдресЭлектроннойПочты);
	//СоответствиеТаблица0.Вставить("H01", ?(ДокументОбьектСсылка.Документы, "1", Null));
	//СоответствиеТаблица0.Вставить("H01G1", ?(ДокументОбьектСсылка.ДокументыВыданые, "1", Null));
	//СоответствиеТаблица0.Вставить("H01G2", ?(ДокументОбьектСсылка.ДокументыПолученые, "1", Null));
	//СоответствиеТаблица0.Вставить("H04", ?(ДокументОбьектСсылка.ИнформацияТолькоПоФилиалу, "1", Null));
	//СоответствиеТаблица0.Вставить("H04G1", ?(ДокументОбьектСсылка.ИнформацияТолькоПоФилиалу, ДокументОбьектСсылка.Филиал, Null));
	//СоответствиеТаблица0.Вставить("H02", ?(ДокументОбьектСсылка.ПоСписку, "1", Null));
	//СоответствиеТаблица0.Вставить("H03", ?(ДокументОбьектСсылка.ИмпортДокументаСКвитанцией, "1", Null));
	Если ДокументОбьектСсылка.Документы Тогда
		СоответствиеТаблица0.Вставить("H01G1D", Формат(ДокументОбьектСсылка.ДокументыНаДату, "ДФ='ddMMyyyy'"));
		СоответствиеТаблица0.Вставить("H01", "1");
		Если ДокументОбьектСсылка.ДокументыВыданые Тогда
			СоответствиеТаблица0.Вставить("H01G1", "1");
		КонецЕсли;
		Если ДокументОбьектСсылка.ДокументыПолученые Тогда
			СоответствиеТаблица0.Вставить("H01G2", "1");
		КонецЕсли;
	КонецЕсли;
	Если ДокументОбьектСсылка.ИнформацияТолькоПоФилиалу Тогда
		СоответствиеТаблица0.Вставить("H04", "1");
		СоответствиеТаблица0.Вставить("H04G1", ДокументОбьектСсылка.Филиал);
	КонецЕсли;
	Если ДокументОбьектСсылка.ИнформацияТолькоПоФилиалуПокупатель Тогда
		СоответствиеТаблица0.Вставить("H05", "1");
		СоответствиеТаблица0.Вставить("H05G1", ДокументОбьектСсылка.ФилиалПокупатель);
	КонецЕсли;
	Если ДокументОбьектСсылка.ПоСписку Тогда
		СоответствиеТаблица0.Вставить("H02", "1");
	КонецЕсли;
	Если ДокументОбьектСсылка.ИмпортДокументаСКвитанцией Тогда
		СоответствиеТаблица0.Вставить("H03", "1");
	КонецЕсли;
	
	Если ДокументОбьектСсылка.ИнформацияПоГлавномуПредприятию Тогда
		СоответствиеТаблица0.Вставить("H06", "1");
	КонецЕсли;
	Если ДокументОбьектСсылка.ИнформацияПоГлавномуПредприятиюПокупатель Тогда
		СоответствиеТаблица0.Вставить("H07", "1");
	КонецЕсли;
	
	МассивЗначений =Новый Массив;
	МассивЗначений.Добавить(СоответствиеТаблица0);
	СоответствиеЗначений.Вставить("0", МассивЗначений);
	
	МассивЗначений =Новый Массив;
	Если ДокументОбьектСсылка.ПоСписку Тогда
		Для Каждого СтрокаТаблицыСписок из ДокументОбьектСсылка.Список Цикл
			СоответствиеТаблица1 = Новый Соответствие;
			СоответствиеТаблица1.Вставить("T1RXXXXG21", СтрокаТаблицыСписок.НомерДокумента);
			СоответствиеТаблица1.Вставить("T1RXXXXG22", СтрокаТаблицыСписок.СпецРежимНалогообложения);
			СоответствиеТаблица1.Вставить("T1RXXXXG23", СтрокаТаблицыСписок.Филиал);
			СоответствиеТаблица1.Вставить("T1RXXXXG3D", Формат(СтрокаТаблицыСписок.ДатаДокумента, "ДФ='ddMMyyyy'"));
			СоответствиеТаблица1.Вставить("T1RXXXXG4S", СтрокаТаблицыСписок.ВидДокумента);
			СоответствиеТаблица1.Вставить("T1RXXXXG5", СтрокаТаблицыСписок.ИННПродавца);
			СоответствиеТаблица1.Вставить("T1RXXXXG6", СтрокаТаблицыСписок.РегистрационныйНомерДокумента);
			
			МассивЗначений.Добавить(СоответствиеТаблица1);
		КонецЦикла;
	Иначе
		СоответствиеТаблица1 = Новый Соответствие;
		СоответствиеТаблица1.Вставить("T1RXXXXG21", Null);
		СоответствиеТаблица1.Вставить("T1RXXXXG22", Null);
		СоответствиеТаблица1.Вставить("T1RXXXXG23", Null);
		СоответствиеТаблица1.Вставить("T1RXXXXG3D", Null);
		СоответствиеТаблица1.Вставить("T1RXXXXG4S", Null);
		СоответствиеТаблица1.Вставить("T1RXXXXG5", Null);
		СоответствиеТаблица1.Вставить("T1RXXXXG6", Null);
		
		МассивЗначений.Добавить(СоответствиеТаблица1);
	КонецЕсли;
	СоответствиеЗначений.Вставить("1", МассивЗначений);
	Возврат Истина;
КонецФункции

Функция СформироватьЭлектронныйДокумент(ДокументСсылка, ЭтоТест, ПредставлениеЭлектронногоДокументаXML, ПредставлениеЭлектронногоДокументаPDF, ИмяФайла, СообщениеОбОшибке) Экспорт
	СоответствиеЗначений = Новый Соответствие;
	КодШаблона = "";
	Если ПолучитьМассивДанныхДляЭлектронногоДокумента(ДокументСсылка, ЭтоТест, КодШаблона, СоответствиеЗначений, СообщениеОбОшибке) Тогда
		ОрганизацияEDI = ДокументСсылка.ОрганизацияEDI;
		
		ПараметрыСозданияДокумента = Новый Соответствие;
		ПараметрыСозданияДокумента.Вставить("Edrpou",   ОрганизацияEDI.Код);
		ПараметрыСозданияДокумента.Вставить("Dept",     ОрганизацияEDI.Филиал);
		ПараметрыСозданияДокумента.Вставить("DocName",  "Запит");
		ПараметрыСозданияДокумента.Вставить("CharCode", КодШаблона);
		ПараметрыСозданияДокумента.Вставить("Tables",   СоответствиеЗначений);
		ЖурналОперации = "";
		ПредставленияЭлектронногоДокумента = скEDI_ОбщегоНазначения.СобратьXMLиPDFПредставленияЭлектронногоДокументаИзСоответствияСДанными(ПараметрыСозданияДокумента, ЖурналОперации);
		ПредставлениеЭлектронногоДокументаXML = ПредставленияЭлектронногоДокумента.ТелоДокумента;
		ПредставлениеЭлектронногоДокументаPDF = ПредставленияЭлектронногоДокумента.ИзображениеДокумента;
		
		Таблица0 = СоответствиеЗначений.Получить("0");
		Таблица0ПерваяСтрока = Неопределено;
		Если ТипЗнч(Таблица0) = Тип("Массив") Тогда
			Если Таблица0.Количество() >= 1 Тогда
				Таблица0ПерваяСтрока = Таблица0[0];
			КонецЕсли;
		КонецЕсли;
		Если Таблица0ПерваяСтрока = Неопределено Тогда
			ИмяФайла = "";
		Иначе
			ИмяФайла = скEDI_ОбщегоНазначения.ПолучитьИмяФайлаНалоговогоДокументаПоРеквизитамШапки(Таблица0ПерваяСтрока);
		КонецЕсли;
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

