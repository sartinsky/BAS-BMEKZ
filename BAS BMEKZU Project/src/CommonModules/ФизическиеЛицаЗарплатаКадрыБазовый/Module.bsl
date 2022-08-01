////////////////////////////////////////////////////////////////////////////////
// ФизическиеЛицаЗарплатаКадрыБазовый: методы, дополняющие функциональность 
// 		справочника ФизическиеЛица
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПроверитьДанныеФизическогоЛица(ДанныеФизическогоЛица, ПравилаПроверки, Ошибки, Отказ, НомерСтроки) Экспорт
	
	Для каждого ПравилоПроверки Из ПравилаПроверки Цикл
		
		Если ПравилаПроверки.ПравилоПроверки = "ФИО" Тогда
			
			ПроверитьФИО(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки);
			
		ИначеЕсли ПравилаПроверки.ПравилоПроверки = "Пол" Тогда
			
			ПроверитьПол(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки);
			
		ИначеЕсли ПравилаПроверки.ПравилоПроверки = "КодПоДРФО" Тогда
			
			ПроверитьКодПоДРФО(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки);
			
			
		ИначеЕсли ПравилаПроверки.ПравилоПроверки = "ДатаРождения" Тогда
			
			ПроверитьДатуРождения(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки);
			
		ИначеЕсли ПравилаПроверки.ПравилоПроверки = "МестоРождения" Тогда
			
			ПроверитьМестоРождения(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки);
			
		ИначеЕсли ПравилаПроверки.ПравилоПроверки = "УдостоверениеЛичности" Тогда
			
			ПроверитьУдостоверениеЛичности(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки);
			
		ИначеЕсли ПравилаПроверки.ПравилоПроверки = "Адрес" Тогда
			
			ПроверитьАдрес(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки);
			
		Иначе
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не найдено правило проверки данных физического лица ""%1""';uk='Не знайдене правило перевірки даних фізичної особи ""%1""'"),
				ПравилаПроверки.ПравилоПроверки);
				
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Если ВидФормы = "ФормаВыбора" Тогда
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты") Тогда
			
			Если Параметры.Свойство("Отбор") Тогда
				
				Если Параметры.Отбор.Свойство("Организация") Тогда
					
					Если ТипЗнч(Параметры.Отбор.Организация) = Тип("СправочникСсылка.Организации") Тогда
						СтандартнаяОбработка = Ложь;
						// ИНАГРО ++
						//ВыбраннаяФорма = "ФормаВыбораСотрудников";
						ВыбраннаяФорма = "ИНАГРО_ФормаВыбораСотрудников";
						// ИНАГРО --
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру, описывающую ошибку проверки данных физического лица
//
// Возвращаемое значение:
//		Структура, содержащая ключи:
//			ТекстОшибки
//			ПолеФормы
//			НомерСтроки
//
Функция ОписаниеОшибкиЗаполненияДанныхФизическогоЛица()
	
	Возврат Новый Структура("ТекстОшибки, ПолеФормы, НомерСтроки");
	
КонецФункции

// Добавляет ошибку в коллекцию ошибок проверки данных физического лица, устанавливает в Истина признак Отказ
//
//	Параметры:
//		Ошибки - Соответствие, если передано Неопределено - будет создано соответствие
//				Ключ соотвествия - ФизическоеЛицо
//		ФизическоеЛицо,
//		ТекстОшибки,
//		Отказ,
//		ПолеФормы - Строка, имя поля формы к которому относится ошибка
//		НомерСтроки - Число, номер строки в многострочном документе
//
Процедура ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(Ошибки, ФизическоеЛицо, ТекстОшибки, Отказ, ПолеФормы = "", НомерСтроки = Неопределено)
	
	Если Ошибки = Неопределено Тогда
		Ошибки = Новый Соответствие;
	КонецЕсли;
	
	КоллекцияОшибок = Ошибки.Получить(ФизическоеЛицо);
	Если КоллекцияОшибок = Неопределено Тогда
		КоллекцияОшибок = Новый Массив;
	КонецЕсли; 
	
	ОшибкаЗаполненияДанных = ОписаниеОшибкиЗаполненияДанныхФизическогоЛица();
	
	ОшибкаЗаполненияДанных.ТекстОшибки = ТекстОшибки;
	ОшибкаЗаполненияДанных.ПолеФормы = ПолеФормы;
	ОшибкаЗаполненияДанных.НомерСтроки = НомерСтроки;
	
	КоллекцияОшибок.Добавить(ОшибкаЗаполненияДанных);
	
	Ошибки.Вставить(ФизическоеЛицо, КоллекцияОшибок);
	
	Отказ = Истина;
	
КонецПроцедуры	

// Проверка данных физических лиц

Процедура ПроверитьФИО(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки)
	
	ТекстОшибки = "";
	
	Фамилия = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным];
	Имя = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДаннымИмя];
	Отчество = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДаннымОтчество];
	
	ФИО = Фамилия + " " + Имя + " " + Отчество;
	Если ПустаяСтрока(Фамилия) ИЛИ ПустаяСтрока(Имя) Тогда
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Сотрудник %1: не указаны фамилия и имя';uk=""Співробітник %1: не зазначено прізвище та ім'я"""),
			ДанныеФизическогоЛица.Наименование);
				
	ИначеЕсли ПустаяСтрока(Имя) Тогда
			
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Сотрудник %1: не указано имя';uk=""Співробітник %1: не вказано ім'я"""),
			ДанныеФизическогоЛица.Наименование);
		
	Иначе
		
		СтранаГражданства = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДаннымСтраныГражданства];
		
		Если СтранаГражданства = Справочники.СтраныМира.Украина Тогда
			
			Если НЕ СтроковыеФункцииКлиентСервер.ТолькоКириллицаВСтроке(ФИО, Ложь, "-. 0123456789") Тогда
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Сотрудник %1: ФИО физического лица должно быть введено русскими буквами';uk='Співробітник %1: ПІБ фізичної особи має бути введено російськими літерами'"),
					ДанныеФизическогоЛица.Наименование);
				
			КонецЕсли;
			
		Иначе
			
			Если НЕ СтроковыеФункцииКлиентСервер.ТолькоКириллицаВСтроке(ФИО, Ложь, "-. 0123456789")
				ИЛИ НЕ СтроковыеФункцииКлиентСервер.ТолькоЛатиницаВСтроке(ФИО, Ложь, "-. 0123456789") Тогда
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Сотрудник %1: ФИО физического лица нерезидента должно быть введено только русскими или только латинскими буквами!';uk='Співробітник %1: ПІБ фізичної особи-нерезидента має бути введено тільки російськими або тільки латинськими літерами!'"),
					ДанныеФизическогоЛица.Наименование);

			КонецЕсли;	
			
		КонецЕсли;

	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
		
		ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
			Ошибки,
			ДанныеФизическогоЛица.ФизическоеЛицо,
			ТекстОшибки,
			Отказ,
			ПравилоПроверки.ПутьКДанным,
			НомерСтроки);
			
	КонецЕсли; 
		
КонецПроцедуры

Процедура ПроверитьКодПоДРФО(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки)
			
	ТекстСообщения = "";
	
	Если НЕ ЗначениеЗаполнено(ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным]) Тогда
		
		Если ПравилоПроверки.ОбязательноКЗаполнению Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Сотрудник %1: не заполнено поле ""%2"" ';uk='Співробітник %1: не заповнено поле ""%2"" '"),
				ДанныеФизическогоЛица.Наименование,
				ПравилоПроверки.ПредставлениеПроверяемогоЭлемента);		
			
		КонецЕсли; 
		
		
	КонецЕсли;	
	
	Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
		
		ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
			Ошибки,
			ДанныеФизическогоЛица.ФизическоеЛицо,
			ТекстОшибки,
			Отказ,
			ПравилоПроверки.ПутьКДанным,
			НомерСтроки);
			
	КонецЕсли; 
		
КонецПроцедуры	

Процедура ПроверитьДатуРождения(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки)
	
	ТекстОшибки = "";
	
	Если НЕ ЗначениеЗаполнено(ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным]) Тогда
		
		Если ПравилоПроверки.ОбязательноКЗаполнению Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Сотрудник %1: не заполнено поле ""%2"" ';uk='Співробітник %1: не заповнено поле ""%2"" '"),
				ДанныеФизическогоЛица.Наименование,
				ПравилоПроверки.ПредставлениеПроверяемогоЭлемента);		
			
		КонецЕсли; 
			
	Иначе
		
		Если ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным] > ПравилоПроверки.ДатаПроверки Тогда
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Сотрудник %1: указанная %2 (%3) не может быть больше даты проверки сведений (%4)';uk='Співробітник %1: зазначена %2 (%3) не може бути більше дати перевірки відомостей (%4)'"),
				ДанныеФизическогоЛица.Наименование,
				ПравилоПроверки.ПредставлениеПроверяемогоЭлемента,
				ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным],
				ПравилоПроверки.ДатаПроверки);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
		
		ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
			Ошибки,
			ДанныеФизическогоЛица.ФизическоеЛицо,
			ТекстОшибки,
			Отказ,
			ПравилоПроверки.ПутьКДанным,
			НомерСтроки);
			
	КонецЕсли; 
		
КонецПроцедуры

Процедура ПроверитьМестоРождения(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки)
	
	Если ПравилоПроверки.ОбязательноКЗаполнению Тогда
		
		МестоРождения = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным];
		МестоРождения = СокрЛП(СтрЗаменить(МестоРождения, ",", ""));
		
		Если ПустаяСтрока(МестоРождения) 
			ИЛИ МестоРождения = "0" Тогда
				
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Сотрудник %1: не заполнено поле %2';uk='Співробітник %1: не заповнено поле %2'"), 
				ДанныеФизическогоЛица.Наименование,
				ПравилоПроверки.ПредставлениеПроверяемогоЭлемента);
																				
			ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
				Ошибки,
				ДанныеФизическогоЛица.ФизическоеЛицо,
				ТекстОшибки,
				Отказ,
				ПравилоПроверки.ПутьКДанным,
				НомерСтроки);
			
		КонецЕсли;	
		
	КонецЕсли; 
	
КонецПроцедуры	

Процедура ПроверитьУдостоверениеЛичности(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки)
	
	ВидДокумента = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным];
	
	Если НЕ ЗначениеЗаполнено(ВидДокумента) Тогда
		
		Если ПравилоПроверки.ОбязательноКЗаполнению Тогда
			
			ТекстОшибки = НСтр("ru='Сотрудник %1: Не указан вид документа, удостоверяющего личность';uk='Співробітник %1: Не вказано вид документа, що посвідчує особу'");
			
			ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
				Ошибки,
				ДанныеФизическогоЛица.ФизическоеЛицо,
				ТекстОшибки,
				Отказ,
				ПравилоПроверки.ПутьКДанным,
				НомерСтроки);
				
		КонецЕсли;
		
	Иначе
		
		ТекстОшибки = "";
		СерияДокумента = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДаннымСерииДокумента];
		Если НЕ ФизическиеЛицаКлиентСервер.СерияДокументаУказанаПравильно(ВидДокумента, СерияДокумента, ТекстОшибки) Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Сотрудник %1: %2!';uk='Співробітник %1: %2!'"),
				ДанныеФизическогоЛица.Наименование,
				ТекстОшибки);
			
			ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
				Ошибки,
				ДанныеФизическогоЛица.ФизическоеЛицо,
				ТекстОшибки,
				Отказ,
				ПравилоПроверки.ПутьКДаннымСерииДокумента,
				НомерСтроки);
				
		КонецЕсли;
		
		ТекстОшибки = "";
		НомерДокумента = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДаннымНомераДокумента];
		Если НЕ ФизическиеЛицаКлиентСервер.НомерДокументаУказанПравильно(ВидДокумента, НомерДокумента, ТекстОшибки) Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Сотрудник %1: %2!';uk='Співробітник %1: %2!'"),
				ДанныеФизическогоЛица.Наименование,
				ТекстОшибки);

			ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
				Ошибки,
				ДанныеФизическогоЛица.ФизическоеЛицо,
				ТекстОшибки,
				Отказ,
				ПравилоПроверки.ПутьКДаннымНомераДокумента,
				НомерСтроки);
				
		КонецЕсли;
			
		Если НЕ ЗначениеЗаполнено(ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДаннымДатыВыдачиДокумента]) Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Сотрудник %1: не указана дата выдачи документа!';uk='Співробітник %1: не вказана дата видачі документа!'"),
				ДанныеФизическогоЛица.Наименование);

			ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
				Ошибки,
				ДанныеФизическогоЛица.ФизическоеЛицо,
				ТекстОшибки,
				Отказ,
				ПравилоПроверки.ПутьКДаннымНомераДокумента,
				НомерСтроки);
				
		КонецЕсли; 	
		
		Если НЕ ЗначениеЗаполнено(ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДаннымКемВыданДокумент]) Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Сотрудник %1: не указано кем выдан документ';uk='Співробітник %1: не вказано ким виданий документ'"),
				ДанныеФизическогоЛица.Наименование);

			ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
				Ошибки,
				ДанныеФизическогоЛица.ФизическоеЛицо,
				ТекстОшибки,
				Отказ,
				ПравилоПроверки.ПутьКДаннымНомераДокумента,
				НомерСтроки);
				
		КонецЕсли; 	
		
	КонецЕсли;
	
КонецПроцедуры	

Процедура ПроверитьАдрес(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки)
	
	ТекстОшибки = "";
	Адрес = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным];
	
	Если НЕ ЗначениеЗаполнено(Адрес) Тогда
		
		Если ПравилоПроверки.ОбязательноКЗаполнению Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Сотрудник %1: - не заполнено поле ""%2""';uk='Співробітник %1: - не заповнено поле ""%2""'"),
				ДанныеФизическогоЛица.Наименование,
				ПравилоПроверки.ПредставлениеПроверяемогоЭлемента);
					
		КонецЕсли;
		
	Иначе
		
		СообщенияПроверки = "";
		
		МассивОшибок = УправлениеКонтактнойИнформацией.ПроверитьАдрес(Адрес);
		
		Если МассивОшибок.Количество() <> 0 Тогда
			
			Для каждого СтруктураОшибки Из МассивОшибок Цикл
				СообщенияПроверки = ?(ПустаяСтрока(СообщенияПроверки), "", СообщенияПроверки + Символы.ПС) + СтруктураОшибки.Сообщение;
			КонецЦикла;
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Сотрудник %1: - поле ""%2"": %3';uk='Співробітник %1: - поле ""%2"": %3'"),
					ДанныеФизическогоЛица.Наименование,
					ПравилоПроверки.ПредставлениеПроверяемогоЭлемента,
					СообщенияПроверки);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
		
		ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
			Ошибки,
			ДанныеФизическогоЛица.ФизическоеЛицо,
			ТекстОшибки,
			Отказ,
			ПравилоПроверки.ПутьКДанным,
			НомерСтроки);
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПроверитьПол(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки)
	
	Пол = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным];
	
	Если НЕ ЗначениеЗаполнено(Пол) Тогда
		
		Если ПравилоПроверки.ОбязательноКЗаполнению Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Сотрудник %1: - не указан пол';uk='Співробітник %1: не вказано стать'"),
					ДанныеФизическогоЛица.Наименование);
					
			ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
				Ошибки,
				ДанныеФизическогоЛица.ФизическоеЛицо,
				ТекстОшибки,
				Отказ,
				ПравилоПроверки.ПутьКДанным,
				НомерСтроки);
				
		КонецЕсли;
				
	КонецЕсли;
	
КонецПроцедуры



