
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОрганизацияEDI = Параметры.ОрганизацияEDI;
	
	ПрочитатьXMLНачальныеНастройки();
	
	Для Каждого ЭлементМассива Из НастройкиПоШаблону Цикл
		НоваяСтрока = ВидыЭлектронныхДокументов.Добавить();
		НоваяСтрока.Значение = ЭлементМассива.Значение.ИмяЭлектронногоДокумента;
		//Проверка наличия выбранного вида документа
		Ссылка = Справочники.скEDI_ВидыЭлектронныхДокументов.НайтиПоНаименованию(НоваяСтрока.Значение, Истина,,ОрганизацияEDI);
		Если Ссылка = Справочники.скEDI_ВидыЭлектронныхДокументов.ПустаяСсылка() Тогда
			НоваяСтрока.Пометка = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНастройку(Команда)
	ЗагрузитьНастройку_Сервер();
	Закрыть();
	Оповестить("скEDI_ИзмененСписокВидовЭлектронныхДокументов", Неопределено);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройку_Сервер()
	
	МассивНастроек = НастройкиПоШаблону.ВыгрузитьЗначения();
	
	Для Каждого Элемент Из ВидыЭлектронныхДокументов Цикл
		Если Не Элемент.Пометка Тогда 
			Продолжить;
		КонецЕсли;
		
		ИмяЭлектронногоДокумента = Элемент.Значение;
		
		Для Каждого ЭлементМассива Из МассивНастроек Цикл
			Если ЭлементМассива.ИмяЭлектронногоДокумента = ИмяЭлектронногоДокумента Тогда
				СписокВидовДокументов1С = Новый СписокЗначений;
				Для Каждого ЭлементНастройкиВыгрузки Из ЭлементМассива.НастройкиВыгрузки Цикл
					Если СписокВидовДокументов1С.НайтиПоЗначению(ЭлементНастройкиВыгрузки.ВидДокумента1С) = Неопределено Тогда
						СписокВидовДокументов1С.Добавить(ЭлементНастройкиВыгрузки.ВидДокумента1С);
					КонецЕсли;
				КонецЦикла;
				
				ВидЭлектронногоДокумента = Справочники.скEDI_ВидыЭлектронныхДокументов.НайтиПоНаименованию(ИмяЭлектронногоДокумента, Истина, , ОрганизацияEDI);
				ТипЭлектронногоДокумента = Перечисления.скEDI_ТипыЭлектронныхДокументов[ЭлементМассива.ТипЭлектронногоДокумента];
				ВариантОпределенияСуммыПоДокументу = Перечисления.скEDI_ВариантыОпределенияСуммыПоДокументу[ЭлементМассива.ВариантОпределенияСуммыПоДокументу];

				Если ВидЭлектронногоДокумента = Справочники.скEDI_ВидыЭлектронныхДокументов.ПустаяСсылка() Тогда
					ВидЭлектронногоДокументаОбъект 				= Справочники.скEDI_ВидыЭлектронныхДокументов.СоздатьЭлемент();
					ВидЭлектронногоДокументаОбъект.Владелец 	= ОрганизацияEDI;
					ВидЭлектронногоДокументаОбъект.Наименование = ИмяЭлектронногоДокумента;
					ВидЭлектронногоДокументаОбъект.ЭтоПредопределенный = Истина;
					ВидЭлектронногоДокументаОбъект.ТипДокумента = ТипЭлектронногоДокумента;
					ВидЭлектронногоДокументаОбъект.ВариантОпределенияСуммыПоДокументу = ВариантОпределенияСуммыПоДокументу;
					Если ТипЭлектронногоДокумента = Перечисления.скEDI_ТипыЭлектронныхДокументов.НалоговаяНакладная
						ИЛИ ТипЭлектронногоДокумента = Перечисления.скEDI_ТипыЭлектронныхДокументов.Приложение2КНалоговойНакладной Тогда
						ВидЭлектронногоДокументаОбъект.ТипПериодаСчетчика = Перечисления.скEDI_ТипПериодаСчетчика.Месяц;
					КонецЕсли;
					ВидЭлектронногоДокументаОбъект.НалоговыйДокументПроверятьСоответствиеПодписантаИСертификата = ЭлементМассива.НалоговыйДокументПроверятьСоответствиеПодписантаИСертификата;
					ВидЭлектронногоДокументаОбъект.НалоговыйДокументВыполнятьПроверкуПоXSDСхеме = ЭлементМассива.НалоговыйДокументВыполнятьПроверкуПоXSDСхеме;
					ВидЭлектронногоДокументаОбъект.НалоговыйДокументВыполнятьЛогическуюПроверку = ЭлементМассива.НалоговыйДокументВыполнятьЛогическуюПроверку;
					ВидЭлектронногоДокументаОбъект.НалоговыйДокументДействияПриОбнаруженииОшибок = ЭлементМассива.НалоговыйДокументДействияПриОбнаруженииОшибок;
					
					ВидЭлектронногоДокументаОбъект.ПометкаУдаления  = Ложь;
					ВидЭлектронногоДокументаОбъект.Записать();
					ВидЭлектронногоДокумента = ВидЭлектронногоДокументаОбъект.Ссылка;
				КонецЕсли;
				
				Для Каждого ЭлементСпискаВидДокумента1С Из СписокВидовДокументов1С Цикл
					
					ВидДокумента1С = Перечисления.скEDI_ВидыДокументов1С[ЭлементСпискаВидДокумента1С.Значение];
					
					// исходящие документы
					Запрос = Новый Запрос;
					Запрос.Текст = 
					"ВЫБРАТЬ
					|	скEDI_ПравилаВыгрузки.ВидЭлектронногоДокумента,
					|	скEDI_ПравилаВыгрузки.ВидДокумента1С,
					|	скEDI_ПравилаВыгрузки.Приоритет,
					|	скEDI_ПравилаВыгрузки.ИмяШаблона,
					|	скEDI_ПравилаВыгрузки.Использование,
					|	скEDI_ПравилаВыгрузки.ЭтоПредопределенный
					|ИЗ
					|	РегистрСведений.скEDI_ПравилаВыгрузки КАК скEDI_ПравилаВыгрузки";
					Запрос.УстановитьПараметр("ВидЭлектронногоДокумента", ВидЭлектронногоДокумента);
					Запрос.УстановитьПараметр("ВидДокумента1С"			, ВидДокумента1С);
					ТЗ_ПравилаВыгрузки = Запрос.Выполнить().Выгрузить();
					
					НаборЗаписейПравилВыгрузки = РегистрыСведений.скEDI_ПравилаВыгрузки.СоздатьНаборЗаписей();
					НаборЗаписейПравилВыгрузки.Отбор.ВидЭлектронногоДокумента.Установить(ВидЭлектронногоДокумента);
					НаборЗаписейПравилВыгрузки.Отбор.ВидДокумента1С.Установить(ВидДокумента1С);
					НаборЗаписейПравилВыгрузки.Прочитать();
					
					Приоритет = 0;
					СписокШаблоновКДобавлению = Новый СписокЗначений;
					Для Каждого СтрокаНабораЗаписейПравилВыгрузки Из НаборЗаписейПравилВыгрузки Цикл
						Для Каждого ЭлементМассиваНастройкиВыгрузки Из ЭлементМассива.НастройкиВыгрузки Цикл
							Приоритет = Макс(Приоритет, СтрокаНабораЗаписейПравилВыгрузки.Приоритет);
							Если СтрокаНабораЗаписейПравилВыгрузки.ИмяШаблона <> ЭлементМассиваНастройкиВыгрузки.ИмяШаблона Тогда
								Продолжить;	
							КонецЕсли;
							
							НайденныеСтроки = ТЗ_ПравилаВыгрузки.НайтиСтроки(Новый Структура("ИмяШаблона", СтрокаНабораЗаписейПравилВыгрузки.ИмяШаблона));
							Если НайденныеСтроки.Количество() = 0 Тогда
								СписокШаблоновКДобавлению.Добавить(ЭлементМассиваНастройкиВыгрузки.ИмяШаблона,, Истина);
								Продолжить;
							КонецЕсли;
							
							Если НЕ СтрокаНабораЗаписейПравилВыгрузки.ЭтоПредопределенный Тогда
								НайденныеСтроки = ТЗ_ПравилаВыгрузки.НайтиСтроки(Новый Структура("ИмяШаблона, ЭтоПредопределенный", СтрокаНабораЗаписейПравилВыгрузки.ИмяШаблона, Истина));
								Если НайденныеСтроки.Количество() = 0 Тогда
									СписокШаблоновКДобавлению.Добавить(ЭлементМассиваНастройкиВыгрузки.ИмяШаблона,, Ложь);
									Продолжить;
								Иначе
									Продолжить;
								КонецЕсли;
							КонецЕсли;
							
							Если ЭлементМассиваНастройкиВыгрузки.ВидДокумента1С = ЭлементСпискаВидДокумента1С.Значение Тогда
								МакетШапка= Справочники.скEDI_ВидыЭлектронныхДокументов.ПолучитьМакет(ЭлементМассиваНастройкиВыгрузки.ИмяМакетаШапка);
								ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
								МакетШапка.Записать(ИмяВременногоФайла);
								ЧтениеХМЛ = новый ЧтениеXML;
								ЧтениеХМЛ.ОткрытьФайл(ИмяВременногоФайла);
								СхемаВыгрузки0 = СериализаторXDTO.ПрочитатьXML(ЧтениеХМЛ,Тип("СхемаКомпоновкиДанных"));  
								
								ИмяМакетаТЧ = "";
								Если ЭлементМассиваНастройкиВыгрузки.Свойство("ИмяМакетаТЧ", ИмяМакетаТЧ) Тогда 
									Если ЗначениеЗаполнено(ИмяМакетаТЧ) Тогда
										МакетТЧ= Справочники.скEDI_ВидыЭлектронныхДокументов.ПолучитьМакет(ЭлементМассиваНастройкиВыгрузки.ИмяМакетаТЧ);
										ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
										МакетТЧ.Записать(ИмяВременногоФайла);
										ЧтениеХМЛ = новый ЧтениеXML;
										ЧтениеХМЛ.ОткрытьФайл(ИмяВременногоФайла);
										СхемаВыгрузки1 = СериализаторXDTO.ПрочитатьXML(ЧтениеХМЛ,Тип("СхемаКомпоновкиДанных")); 
									КонецЕсли;
								Иначе
									СхемаВыгрузки1 = Неопределено;
								КонецЕсли;
								
								СтрокаНабораЗаписейПравилВыгрузки.Схема0 	  = Новый ХранилищеЗначения(СхемаВыгрузки0);
								Если СхемаВыгрузки1 <> Неопределено Тогда
									СтрокаНабораЗаписейПравилВыгрузки.Схема1 = Новый ХранилищеЗначения(СхемаВыгрузки1);
								КонецЕсли;
								//НаборЗаписейПравилВыгрузки.Записать();
								//проверяем есть ли такой непредопределенный
								НайденныеСтроки = ТЗ_ПравилаВыгрузки.НайтиСтроки(Новый Структура("ИмяШаблона, ЭтоПредопределенный", СтрокаНабораЗаписейПравилВыгрузки.ИмяШаблона, Ложь));
								Если НайденныеСтроки.Количество() = 0 Тогда
									СтрокаНабораЗаписейПравилВыгрузки.Использование = Истина;
								Иначе
									СтрокаНабораЗаписейПравилВыгрузки.Использование = Ложь;
								КонецЕсли;
							КонецЕсли;
						КонецЦикла;
					КонецЦикла;
					
					НаборЗаписейПустой = НаборЗаписейПравилВыгрузки.Количество() = 0;
					
					Для Каждого ЭлементМассиваНастройкиВыгрузки Из ЭлементМассива.НастройкиВыгрузки Цикл
						Если ЭлементМассиваНастройкиВыгрузки.ВидДокумента1С = ЭлементСпискаВидДокумента1С.Значение Тогда
							Если НаборЗаписейПустой Тогда
								Использовать = Истина;
							Иначе
								НайденныйШаблон = СписокШаблоновКДобавлению.НайтиПоЗначению(ЭлементМассиваНастройкиВыгрузки.ИмяШаблона);
								Если НайденныйШаблон = Неопределено Тогда 
									Продолжить;
								Иначе 
									Использовать = НайденныйШаблон.Пометка;
								КонецЕсли;
							КонецЕсли;
							Приоритет = Приоритет + 1;
							МакетШапка= Справочники.скEDI_ВидыЭлектронныхДокументов.ПолучитьМакет(ЭлементМассиваНастройкиВыгрузки.ИмяМакетаШапка);
							ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
							МакетШапка.Записать(ИмяВременногоФайла);
							ЧтениеХМЛ = новый ЧтениеXML;
							ЧтениеХМЛ.ОткрытьФайл(ИмяВременногоФайла);
							СхемаВыгрузки0 = СериализаторXDTO.ПрочитатьXML(ЧтениеХМЛ,Тип("СхемаКомпоновкиДанных"));  
							
							ИмяМакетаТЧ = "";
							Если ЭлементМассиваНастройкиВыгрузки.Свойство("ИмяМакетаТЧ", ИмяМакетаТЧ) Тогда 
								Если ЗначениеЗаполнено(ИмяМакетаТЧ) Тогда
									МакетТЧ= Справочники.скEDI_ВидыЭлектронныхДокументов.ПолучитьМакет(ЭлементМассиваНастройкиВыгрузки.ИмяМакетаТЧ);
									ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
									МакетТЧ.Записать(ИмяВременногоФайла);
									ЧтениеХМЛ = новый ЧтениеXML;
									ЧтениеХМЛ.ОткрытьФайл(ИмяВременногоФайла);
									СхемаВыгрузки1 = СериализаторXDTO.ПрочитатьXML(ЧтениеХМЛ,Тип("СхемаКомпоновкиДанных")); 
								КонецЕсли;
							Иначе
								СхемаВыгрузки1 = Неопределено;
							КонецЕсли;
							
							НоваяСтрокаНабораЗаписейПравилВыгрузки = НаборЗаписейПравилВыгрузки.Добавить();
							НоваяСтрокаНабораЗаписейПравилВыгрузки.ВидЭлектронногоДокумента = ВидЭлектронногоДокумента;
							НоваяСтрокаНабораЗаписейПравилВыгрузки.ВидДокумента1С 			= ВидДокумента1С;
							НоваяСтрокаНабораЗаписейПравилВыгрузки.ЕДРПОУВладельцаШаблона	 = ЭлементМассиваНастройкиВыгрузки.ЕДРПОУВладельцаШаблона;
							НоваяСтрокаНабораЗаписейПравилВыгрузки.ИмяШаблона				= ЭлементМассиваНастройкиВыгрузки.ИмяШаблона;
							НоваяСтрокаНабораЗаписейПравилВыгрузки.ВерсияШаблона			 = ЭлементМассиваНастройкиВыгрузки.ВерсияШаблона;
							НоваяСтрокаНабораЗаписейПравилВыгрузки.Наименование				= ЭлементМассиваНастройкиВыгрузки.Наименование;
							НоваяСтрокаНабораЗаписейПравилВыгрузки.Приоритет				= Приоритет;
							НоваяСтрокаНабораЗаписейПравилВыгрузки.Схема0 = Новый ХранилищеЗначения(СхемаВыгрузки0);
							Если СхемаВыгрузки1 <> Неопределено Тогда
								НоваяСтрокаНабораЗаписейПравилВыгрузки.Схема1 = Новый ХранилищеЗначения(СхемаВыгрузки1);
							КонецЕсли;
							НоваяСтрокаНабораЗаписейПравилВыгрузки.ЭтоПредопределенный = Истина;
							НоваяСтрокаНабораЗаписейПравилВыгрузки.Использование = Использовать;
						КонецЕсли;
					КонецЦикла;
					НаборЗаписейПравилВыгрузки.Записать(Истина);
				КонецЦикла;
				
				Для Каждого УсловиеДокумента Из ЭлементМассива.НастройкиСоответствияВидовЭлектронныхИУчетныхДокументов Цикл
					СоответствиеВидовЭлектронныхИУчетныхДокументов = РегистрыСведений.скEDI_СоответствиеВидовЭлектронныхИУчетныхДокументов.СоздатьМенеджерЗаписи();
					СоответствиеВидовЭлектронныхИУчетныхДокументов.ВидЭлектронногоДокумента = ВидЭлектронногоДокумента;
					
					лпВидДокумент1С = Перечисления.скEDI_ВидыДокументов1С[УсловиеДокумента.ВидДокументаДляНастройки];
					СоответствиеВидовЭлектронныхИУчетныхДокументов.ВидДокумента1С = лпВидДокумент1С;
					
					СоответствиеВидовЭлектронныхИУчетныхДокументов.Прочитать();
					Если не СоответствиеВидовЭлектронныхИУчетныхДокументов.Выбран() Тогда
						СоответствиеВидовЭлектронныхИУчетныхДокументов = РегистрыСведений.скEDI_СоответствиеВидовЭлектронныхИУчетныхДокументов.СоздатьМенеджерЗаписи();
						СоответствиеВидовЭлектронныхИУчетныхДокументов.ВидЭлектронногоДокумента = ВидЭлектронногоДокумента;
						
						лпВидДокумент1С = Перечисления.скEDI_ВидыДокументов1С[УсловиеДокумента.ВидДокументаДляНастройки];
						СоответствиеВидовЭлектронныхИУчетныхДокументов.ВидДокумента1С = лпВидДокумент1С;
						
						СоответствиеВидовЭлектронныхИУчетныхДокументов.ДолжныБытьУслуги = УсловиеДокумента.ЗаполненыУслуги = "Истина";
						СоответствиеВидовЭлектронныхИУчетныхДокументов.ДолжныБытьТовары = УсловиеДокумента.ЗаполненыТовары = "Истина";
						
						лпВхИсх = Перечисления.скEDI_ВхИсхЭлектронныйДокумент[УсловиеДокумента.ВходящийИсходящий];
						СоответствиеВидовЭлектронныхИУчетныхДокументов.ВхИсх	   = лпВхИсх;
						СоответствиеВидовЭлектронныхИУчетныхДокументов.Использование = Истина;
						СоответствиеВидовЭлектронныхИУчетныхДокументов.ДатаС	   = НачалоДня(ТекущаяДата());
						СоответствиеВидовЭлектронныхИУчетныхДокументов.ТекстЗапроса= УсловиеДокумента.ТекстЗапроса;
						СоответствиеВидовЭлектронныхИУчетныхДокументов.Записать(Истина);
					КонецЕсли;
				КонецЦикла;	
				
				// входящие документы
				Запрос = Новый Запрос;
				Запрос.Текст = 
				"ВЫБРАТЬ
				|	скEDI_ПравилаЗагрузки.Организация,
				|	скEDI_ПравилаЗагрузки.ИмяШаблона,
				|	скEDI_ПравилаЗагрузки.Приоритет,
				|	скEDI_ПравилаЗагрузки.ВидЭлектронногоДокумента,
				|	скEDI_ПравилаЗагрузки.Использование,
				|	скEDI_ПравилаЗагрузки.ВидДокумента1С,
				|	скEDI_ПравилаЗагрузки.ЭтоПредопределенный
				|ИЗ
				|	РегистрСведений.скEDI_ПравилаЗагрузки КАК скEDI_ПравилаЗагрузки
				|ГДЕ
				|	скEDI_ПравилаЗагрузки.Организация = &Организация
				|	И скEDI_ПравилаЗагрузки.ВидЭлектронногоДокумента = &ВидЭлектронногоДокумента";
				
				Запрос.УстановитьПараметр("ВидЭлектронногоДокумента", ВидЭлектронногоДокумента);
				Запрос.УстановитьПараметр("Организация", ОрганизацияEDI);
				ТЗ_ПравилаЗагрузкиДокументов = Запрос.Выполнить().Выгрузить();
				
				Для Каждого ЭлементМассиваНастройкиЗагрузки Из ЭлементМассива.НастройкиЗагрузки Цикл
					ВидДокумента1С = Перечисления.скEDI_ВидыДокументов1С[ЭлементМассиваНастройкиЗагрузки.ВидДокумента1С];
					ЕДРПОУВладельцаШаблона = ЭлементМассиваНастройкиЗагрузки.ЕДРПОУВладельцаШаблона;
					ИмяШаблона = ЭлементМассиваНастройкиЗагрузки.ИмяШаблона;
					ВерсияШаблона = ЭлементМассиваНастройкиЗагрузки.ВерсияШаблона;
					НаименованиеШаблона = ЭлементМассиваНастройкиЗагрузки.Наименование;
					
					НаборЗаписейПравилЗагрузки = РегистрыСведений.скEDI_ПравилаЗагрузки.СоздатьНаборЗаписей();
					НаборЗаписейПравилЗагрузки.Отбор.Организация.Установить(ОрганизацияEDI);
					НаборЗаписейПравилЗагрузки.Отбор.ЕДРПОУВладельцаШаблона.Установить(ЕДРПОУВладельцаШаблона);
					НаборЗаписейПравилЗагрузки.Отбор.ИмяШаблона.Установить(ИмяШаблона);
					НаборЗаписейПравилЗагрузки.Отбор.ВерсияШаблона.Установить(ВерсияШаблона);
					НаборЗаписейПравилЗагрузки.Прочитать();
					
					Приоритет = 0;
					СписокШаблоновКДобавлению = Новый СписокЗначений;
					Для Каждого СтрокаНабораЗаписейПравилЗагрузки Из НаборЗаписейПравилЗагрузки Цикл   
						
						Приоритет = Макс(Приоритет, СтрокаНабораЗаписейПравилЗагрузки.Приоритет);
						
						НайденныеСтроки = ТЗ_ПравилаЗагрузкиДокументов.НайтиСтроки(Новый Структура("ИмяШаблона", ИмяШаблона));
						Если НайденныеСтроки.Количество() = 0 Тогда
							СписокШаблоновКДобавлению.Добавить(ИмяШаблона,, Истина);
							Продолжить;
						КонецЕсли;
						
						Если НЕ СтрокаНабораЗаписейПравилЗагрузки.ЭтоПредопределенный Тогда
							НайденныеСтроки = ТЗ_ПравилаЗагрузкиДокументов.НайтиСтроки(Новый Структура("ИмяШаблона, ЭтоПредопределенный", СтрокаНабораЗаписейПравилЗагрузки.ИмяШаблона, Истина));
							Если НайденныеСтроки.Количество() = 0 Тогда
								СписокШаблоновКДобавлению.Добавить(ИмяШаблона,, Ложь);
								Продолжить;
							Иначе
								Продолжить;
							КонецЕсли;
						КонецЕсли;

						МакетЗагрузки = Справочники.скEDI_ВидыЭлектронныхДокументов.ПолучитьМакет(ЭлементМассиваНастройкиЗагрузки.ИмяМакетаЗагрузки);
						
						СтрокаНабораЗаписейПравилЗагрузки.Схема 		 = Новый ХранилищеЗначения(МакетЗагрузки);
						НаборЗаписейПравилЗагрузки.Записать();
						НайденныеСтроки = ТЗ_ПравилаЗагрузкиДокументов.НайтиСтроки(Новый Структура("ИмяШаблона, ЭтоПредопределенный", СтрокаНабораЗаписейПравилЗагрузки.ИмяШаблона, Ложь));
						Если НайденныеСтроки.Количество() = 0 Тогда
							СтрокаНабораЗаписейПравилЗагрузки.Использование = Истина;
						Иначе
							СтрокаНабораЗаписейПравилЗагрузки.Использование = Ложь;
						КонецЕсли;
					КонецЦикла;
					
					НаборЗаписейПустой = НаборЗаписейПравилЗагрузки.Количество() = 0;
					
					Если НаборЗаписейПустой Тогда
						Использовать = Истина;
					Иначе
						НайденныйШаблон = СписокШаблоновКДобавлению.НайтиПоЗначению(ИмяШаблона);
						Если НайденныйШаблон = Неопределено Тогда 
							Продолжить;
						Иначе 
							Использовать = НайденныйШаблон.Пометка;
						КонецЕсли;
					КонецЕсли;

					Приоритет = Приоритет + 1;
					МакетЗагрузки = Справочники.скEDI_ВидыЭлектронныхДокументов.ПолучитьМакет(ЭлементМассиваНастройкиЗагрузки.ИмяМакетаЗагрузки);
					
					ПравилаЗагрузки = НаборЗаписейПравилЗагрузки.Добавить();
					ПравилаЗагрузки.Организация = ОрганизацияEDI;
					ПравилаЗагрузки.ЕДРПОУВладельцаШаблона  = ЕДРПОУВладельцаШаблона;
					ПравилаЗагрузки.ИмяШаблона  = ИмяШаблона;
					ПравилаЗагрузки.ВерсияШаблона  = ВерсияШаблона;
					ПравилаЗагрузки.Приоритет   = Приоритет;
					ПравилаЗагрузки.ВидЭлектронногоДокумента = ВидЭлектронногоДокумента;
					ПравилаЗагрузки.Схема 		   = Новый ХранилищеЗначения(МакетЗагрузки);;
					ПравилаЗагрузки.Использование  = Использовать;
					ПравилаЗагрузки.ВидДокумента1С = ВидДокумента1С;
					ПравилаЗагрузки.Наименование   = НаименованиеШаблона;
					ПравилаЗагрузки.ЭтоПредопределенный = Истина;
					ПравилаЗагрузки.ТиповаяСхемма = ЭлементМассиваНастройкиЗагрузки.ТиповаяСхемма;
					НаборЗаписейПравилЗагрузки.Записать();
				КонецЦикла;
				
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;	
	
КонецПроцедуры	

&НаСервере
Процедура ПрочитатьXMLНачальныеНастройки()
	
	ИДКонфигурации = скEDI_НастройкиПодКонфигурацию.ИДКонфигурации();
	
	Если ИДКонфигурации = "БП" Тогда
		НачальныеНастройки = Справочники.скEDI_ВидыЭлектронныхДокументов.ПолучитьМакет("НачальноеЗаполнение_БУХ").ПолучитьТекст();
	ИначеЕсли ИДКонфигурации = "БП20" Тогда
		НачальныеНастройки = Справочники.скEDI_ВидыЭлектронныхДокументов.ПолучитьМакет("НачальноеЗаполнение_БУХ_2_0").ПолучитьТекст();
	ИначеЕсли ИДКонфигурации = "УТП" Тогда
		НачальныеНастройки = Справочники.скEDI_ВидыЭлектронныхДокументов.ПолучитьМакет("НачальноеЗаполнение_УТП").ПолучитьТекст();
	ИначеЕсли ИДКонфигурации = "УПП" Тогда
		НачальныеНастройки = Справочники.скEDI_ВидыЭлектронныхДокументов.ПолучитьМакет("НачальноеЗаполнение_УПП").ПолучитьТекст();
	ИначеЕсли ИДКонфигурации = "УТ" Тогда
		НачальныеНастройки = Справочники.скEDI_ВидыЭлектронныхДокументов.ПолучитьМакет("НачальноеЗаполнение_УТ").ПолучитьТекст();
	ИначеЕсли ИДКонфигурации = "FlyDoc" Тогда
		НачальныеНастройки = Справочники.скEDI_ВидыЭлектронныхДокументов.ПолучитьМакет("НачальноеЗаполнение_FlyDoc").ПолучитьТекст();
	ИначеЕсли ИДКонфигурации = "BASУТ" Тогда
		НачальныеНастройки = Справочники.скEDI_ВидыЭлектронныхДокументов.ПолучитьМакет("НачальноеЗаполнение_BASУТ").ПолучитьТекст();
	ИначеЕсли ИДКонфигурации = "BASКУП" Тогда
		НачальныеНастройки = Справочники.скEDI_ВидыЭлектронныхДокументов.ПолучитьМакет("НачальноеЗаполнение_BASКУП").ПолучитьТекст();
	ИначеЕсли ИДКонфигурации = "BASERP" Тогда
		НачальныеНастройки = Справочники.скEDI_ВидыЭлектронныхДокументов.ПолучитьМакет("НачальноеЗаполнение_BASERP").ПолучитьТекст();
	ИначеЕсли ИДКонфигурации = "BASERP25" Тогда
		НачальныеНастройки = Справочники.скEDI_ВидыЭлектронныхДокументов.ПолучитьМакет("НачальноеЗаполнение_BASERP25").ПолучитьТекст();
	ИначеЕсли ИДКонфигурации = "УНФ" Тогда
		НачальныеНастройки = Справочники.скEDI_ВидыЭлектронныхДокументов.ПолучитьМакет("НачальноеЗаполнение_УНФ").ПолучитьТекст();
	Иначе 
		НачальныеНастройки = Справочники.скEDI_ВидыЭлектронныхДокументов.ПолучитьМакет("НачальноеЗаполнение_Прочее").ПолучитьТекст();
	КонецЕсли;
	
	ЧтениеXML = новый ЧтениеXML;
	
	ЧтениеXML.УстановитьСтроку(НачальныеНастройки);
	ЧтениеXML.Прочитать();
	
	мДОМ = Новый ПостроительDOM;
	мДокументДОМ 	  = мДОМ.Прочитать(ЧтениеXML);
	
	МассивНастроек = Новый Массив;
	
	Для Каждого ДочернийУзел1 Из мДокументДОМ.ДочерниеУзлы Цикл
		Если ВРег(ДочернийУзел1.ИмяУзла) = ВРег("ВидыЭлектронныхДокументов") Тогда
			Для Каждого ДочернийУзел2 Из ДочернийУзел1.ДочерниеУзлы Цикл
				Если ВРег(ДочернийУзел2.ИмяУзла) = ВРег("ВидЭлектронногоДокумента") Тогда
					АтрибутИмяДокумента = ДочернийУзел2.Атрибуты.ПолучитьИменованныйЭлемент("ИмяДокумента"); 
					Если АтрибутИмяДокумента = Неопределено Тогда
						Продолжить;
					КонецЕсли; 
					
					АтрибутТипДокумента = ДочернийУзел2.Атрибуты.ПолучитьИменованныйЭлемент("ТипЭлектронногоДокумента");
					АтрибутВариантОпределенияСумм = ДочернийУзел2.Атрибуты.ПолучитьИменованныйЭлемент("ВариантОпределенияСуммыПоДокументу");

					Если АтрибутТипДокумента =  Неопределено Тогда
						Продолжить;
					КонецЕсли;
					СтруктураНастройки_XML = Новый Структура;
					СтруктураНастройки_XML.Вставить("ИмяЭлектронногоДокумента", АтрибутИмяДокумента.ТекстовоеСодержимое);
					СтруктураНастройки_XML.Вставить("ТипЭлектронногоДокумента", АтрибутТипДокумента.ТекстовоеСодержимое);
					СтруктураНастройки_XML.Вставить("ВариантОпределенияСуммыПоДокументу", АтрибутВариантОпределенияСумм.ТекстовоеСодержимое);
					
					АтрибутНалоговыйДокументПроверятьСоответствиеПодписантаИСертификата = ДочернийУзел2.Атрибуты.ПолучитьИменованныйЭлемент("НалоговыйДокументПроверятьСоответствиеПодписантаИСертификата");
					Если АтрибутНалоговыйДокументПроверятьСоответствиеПодписантаИСертификата = Неопределено Тогда
						СтруктураНастройки_XML.Вставить("НалоговыйДокументПроверятьСоответствиеПодписантаИСертификата", Ложь);
					Иначе
						СтруктураНастройки_XML.Вставить("НалоговыйДокументПроверятьСоответствиеПодписантаИСертификата", ВРег(АтрибутНалоговыйДокументПроверятьСоответствиеПодписантаИСертификата.ТекстовоеСодержимое) = ВРег("Истина"));
					КонецЕсли;
					
					АтрибутНалоговыйДокументВыполнятьПроверкуПоXSDСхеме = ДочернийУзел2.Атрибуты.ПолучитьИменованныйЭлемент("НалоговыйДокументВыполнятьПроверкуПоXSDСхеме");
					Если АтрибутНалоговыйДокументВыполнятьПроверкуПоXSDСхеме = Неопределено Тогда
						СтруктураНастройки_XML.Вставить("НалоговыйДокументВыполнятьПроверкуПоXSDСхеме", Ложь);
					Иначе
						СтруктураНастройки_XML.Вставить("НалоговыйДокументВыполнятьПроверкуПоXSDСхеме", ВРег(АтрибутНалоговыйДокументВыполнятьПроверкуПоXSDСхеме.ТекстовоеСодержимое) = ВРег("Истина"));
					КонецЕсли;
					
					АтрибутНалоговыйДокументВыполнятьЛогическуюПроверку = ДочернийУзел2.Атрибуты.ПолучитьИменованныйЭлемент("НалоговыйДокументВыполнятьЛогическуюПроверку");
					Если АтрибутНалоговыйДокументВыполнятьЛогическуюПроверку = Неопределено Тогда
						СтруктураНастройки_XML.Вставить("НалоговыйДокументВыполнятьЛогическуюПроверку", Ложь);
					Иначе
						СтруктураНастройки_XML.Вставить("НалоговыйДокументВыполнятьЛогическуюПроверку", ВРег(АтрибутНалоговыйДокументВыполнятьЛогическуюПроверку.ТекстовоеСодержимое) = ВРег("Истина"));
					КонецЕсли;
					
					АтрибутНалоговыйДокументДействияПриОбнаруженииОшибок = ДочернийУзел2.Атрибуты.ПолучитьИменованныйЭлемент("НалоговыйДокументДействияПриОбнаруженииОшибок");
					Если АтрибутНалоговыйДокументДействияПриОбнаруженииОшибок = Неопределено Тогда
						СтруктураНастройки_XML.Вставить("НалоговыйДокументДействияПриОбнаруженииОшибок", Перечисления.скEDI_ДействияПриОбнаруженииОшибок.ПустаяСсылка());
					Иначе
						СтруктураНастройки_XML.Вставить("НалоговыйДокументДействияПриОбнаруженииОшибок", Перечисления.скEDI_ДействияПриОбнаруженииОшибок[АтрибутНалоговыйДокументДействияПриОбнаруженииОшибок.ТекстовоеСодержимое]);
					КонецЕсли;
					
					МассивНастройкиВыгрузки = Новый Массив;
					МассивНастройкиЗагрузки = Новый Массив;
					МассивНастройкиСоответствияВидовЭлектронныхИУчетныхДокументов = Новый Массив;
					
					Для Каждого ДочернийУзел3 Из ДочернийУзел2.ДочерниеУзлы Цикл 
						Если ВРег(ДочернийУзел3.ИмяУзла) = ВРег("НастройкиВыгрузки") Тогда
							Для Каждого ДочернийУзел4 Из ДочернийУзел3.ДочерниеУзлы Цикл 
								Если ВРег(ДочернийУзел4.ИмяУзла) = ВРег("ИмяШаблона") Тогда
									АтрибутИмяШаблона = ДочернийУзел4.Атрибуты.ПолучитьИменованныйЭлемент("ИмяШаблона"); 
									Если АтрибутИмяШаблона = Неопределено Тогда
										Продолжить;
									КонецЕсли;
									
									СтруктураНастроекВыгрузки = Новый Структура("Наименование,ЕДРПОУВладельцаШаблона,ИмяШаблона,ВерсияШаблона,ВидДокумента1С,ИмяМакетаШапка,ИмяМакетаТЧ");
									СтруктураНастроекВыгрузки.ИмяШаблона = АтрибутИмяШаблона.ТекстовоеСодержимое;
									
									АтрибутЕДРПОУВладельцаШаблона = ДочернийУзел4.Атрибуты.ПолучитьИменованныйЭлемент("ЕДРПОУВладельцаШаблона"); 
									Если АтрибутЕДРПОУВладельцаШаблона <> Неопределено Тогда
										СтруктураНастроекВыгрузки.ЕДРПОУВладельцаШаблона = АтрибутЕДРПОУВладельцаШаблона.ТекстовоеСодержимое;
									КонецЕсли;
									АтрибутВерсияШаблона = ДочернийУзел4.Атрибуты.ПолучитьИменованныйЭлемент("ВерсияШаблона"); 
									Если АтрибутВерсияШаблона <> Неопределено Тогда
										СтруктураНастроекВыгрузки.ВерсияШаблона = АтрибутВерсияШаблона.ТекстовоеСодержимое;
									КонецЕсли;
									
									Для Каждого ДочернийУзел5 Из ДочернийУзел4.ДочерниеУзлы Цикл 
										Если ВРег(ДочернийУзел5.ИмяУзла) = ВРег("ВидДокумента1С") Тогда
											СтруктураНастроекВыгрузки.ВидДокумента1С = ДочернийУзел5.ТекстовоеСодержимое;
										ИначеЕсли ВРег(ДочернийУзел5.ИмяУзла) = ВРег("ИмяМакетаШапка") Тогда
											СтруктураНастроекВыгрузки.ИмяМакетаШапка = ДочернийУзел5.ТекстовоеСодержимое;
										ИначеЕсли ВРег(ДочернийУзел5.ИмяУзла) = ВРег("ИмяМакетаТЧ") Тогда
											СтруктураНастроекВыгрузки.ИмяМакетаТЧ = ДочернийУзел5.ТекстовоеСодержимое;
										ИначеЕсли ВРег(ДочернийУзел5.ИмяУзла) = ВРег("Наименование") Тогда
											СтруктураНастроекВыгрузки.Наименование = ДочернийУзел5.ТекстовоеСодержимое;
										КонецЕсли;
									КонецЦикла;
									МассивНастройкиВыгрузки.Добавить(СтруктураНастроекВыгрузки);
								КонецЕсли;
							КонецЦикла;
						ИначеЕсли ВРег(ДочернийУзел3.ИмяУзла) = ВРег("НастройкиЗагрузки") Тогда
							Для Каждого ДочернийУзел4 Из ДочернийУзел3.ДочерниеУзлы Цикл 
								Если ВРег(ДочернийУзел4.ИмяУзла) = ВРег("ИмяШаблона") Тогда
									АтрибутИмяШаблона = ДочернийУзел4.Атрибуты.ПолучитьИменованныйЭлемент("ИмяШаблона"); 
									Если АтрибутИмяШаблона = Неопределено Тогда
										Продолжить;
									КонецЕсли;
									
									СтруктураНастроекЗагрузки = Новый Структура("Наименование,ЕДРПОУВладельцаШаблона,ИмяШаблона,ВерсияШаблона,ВидДокумента1С,ИмяМакетаЗагрузки,ТиповаяСхемма");
									СтруктураНастроекЗагрузки.ИмяШаблона = АтрибутИмяШаблона.ТекстовоеСодержимое;
									СтруктураНастроекЗагрузки.ТиповаяСхемма = Ложь;
									
									АтрибутЕДРПОУВладельцаШаблона = ДочернийУзел4.Атрибуты.ПолучитьИменованныйЭлемент("ЕДРПОУВладельцаШаблона"); 
									Если АтрибутЕДРПОУВладельцаШаблона <> Неопределено Тогда
										СтруктураНастроекЗагрузки.ЕДРПОУВладельцаШаблона = АтрибутЕДРПОУВладельцаШаблона.ТекстовоеСодержимое;
									КонецЕсли;
									АтрибутВерсияШаблона = ДочернийУзел4.Атрибуты.ПолучитьИменованныйЭлемент("ВерсияШаблона"); 
									Если АтрибутВерсияШаблона <> Неопределено Тогда
										СтруктураНастроекЗагрузки.ВерсияШаблона = АтрибутВерсияШаблона.ТекстовоеСодержимое;
									КонецЕсли;
									
									Для Каждого ДочернийУзел5 Из ДочернийУзел4.ДочерниеУзлы Цикл 
										Если ВРег(ДочернийУзел5.ИмяУзла) = ВРег("ВидДокумента1С") Тогда
											СтруктураНастроекЗагрузки.ВидДокумента1С = ДочернийУзел5.ТекстовоеСодержимое;
										ИначеЕсли ВРег(ДочернийУзел5.ИмяУзла) = ВРег("ИмяМакетаЗагрузки") Тогда
											СтруктураНастроекЗагрузки.ИмяМакетаЗагрузки = ДочернийУзел5.ТекстовоеСодержимое;
										ИначеЕсли ВРег(ДочернийУзел5.ИмяУзла) = ВРег("Наименование") Тогда
											СтруктураНастроекЗагрузки.Наименование = ДочернийУзел5.ТекстовоеСодержимое;
										ИначеЕсли ВРег(ДочернийУзел5.ИмяУзла) = ВРег("ТиповаяСхемма") Тогда
											СтруктураНастроекЗагрузки.ТиповаяСхемма = ?(ВРег(СокрЛП(ДочернийУзел5.ТекстовоеСодержимое)) = "ИСТИНА", Истина, Ложь);
										КонецЕсли;
									КонецЦикла;
									МассивНастройкиЗагрузки.Добавить(СтруктураНастроекЗагрузки);
								КонецЕсли;
							КонецЦикла;
						ИначеЕсли ВРег(ДочернийУзел3.ИмяУзла) = ВРег("НастройкиСоответствияВидовЭлектронныхИУчетныхДокументов") Тогда
							Для Каждого ДочернийУзел4 Из ДочернийУзел3.ДочерниеУзлы Цикл 
								Если ВРег(ДочернийУзел4.ИмяУзла) = ВРег("Условие") Тогда
									
									СтруктураНастроекСоответствияВидовЭлектронныхИУчетныхДокументов = Новый Структура("ВидДокументаДляНастройки,ЗаполненыУслуги,ЗаполненыТовары,ВходящийИсходящий,ТекстЗапроса");
									
									Для Каждого ДочернийУзел5 Из ДочернийУзел4.ДочерниеУзлы Цикл 
										Если ВРег(ДочернийУзел5.ИмяУзла) = ВРег("ВидДокументаДляНастройки") Тогда
											СтруктураНастроекСоответствияВидовЭлектронныхИУчетныхДокументов.ВидДокументаДляНастройки = ДочернийУзел5.ТекстовоеСодержимое;
										ИначеЕсли ВРег(ДочернийУзел5.ИмяУзла) = ВРег("ЗаполненыУслуги") Тогда
											СтруктураНастроекСоответствияВидовЭлектронныхИУчетныхДокументов.ЗаполненыУслуги = ДочернийУзел5.ТекстовоеСодержимое;
										ИначеЕсли ВРег(ДочернийУзел5.ИмяУзла) = ВРег("ЗаполненыТовары") Тогда
											СтруктураНастроекСоответствияВидовЭлектронныхИУчетныхДокументов.ЗаполненыТовары = ДочернийУзел5.ТекстовоеСодержимое;
										ИначеЕсли ВРег(ДочернийУзел5.ИмяУзла) = ВРег("ВходящийИсходящий") Тогда
											СтруктураНастроекСоответствияВидовЭлектронныхИУчетныхДокументов.ВходящийИсходящий = ДочернийУзел5.ТекстовоеСодержимое;
										ИначеЕсли ВРег(ДочернийУзел5.ИмяУзла) = ВРег("ТекстЗапроса") Тогда
											СтруктураНастроекСоответствияВидовЭлектронныхИУчетныхДокументов.ТекстЗапроса = ДочернийУзел5.ТекстовоеСодержимое;											
										КонецЕсли;
									КонецЦикла;
									МассивНастройкиСоответствияВидовЭлектронныхИУчетныхДокументов.Добавить(СтруктураНастроекСоответствияВидовЭлектронныхИУчетныхДокументов);
								КонецЕсли;
							КонецЦикла;
						КонецЕсли;
						СтруктураНастройки_XML.Вставить("НастройкиВыгрузки", МассивНастройкиВыгрузки);
						СтруктураНастройки_XML.Вставить("НастройкиЗагрузки", МассивНастройкиЗагрузки);
						СтруктураНастройки_XML.Вставить("НастройкиСоответствияВидовЭлектронныхИУчетныхДокументов", МассивНастройкиСоответствияВидовЭлектронныхИУчетныхДокументов);
					КонецЦикла;
					МассивНастроек.Добавить(СтруктураНастройки_XML);
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
	КонецЦикла;
	
	НастройкиПоШаблону.ЗагрузитьЗначения(МассивНастроек);
	
	ЧтениеXML.Закрыть();
	
КонецПроцедуры









