
Процедура ПередУдалением(Отказ)
	//Отказ = Не МонопольныйРежим();
КонецПроцедуры


Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Состояние = Перечисления.скEDI_СостоянияДополнительныхЭлектронныхДокументовДФС.Создан;
	Ответственный = ПараметрыСеанса.ТекущийПользователь;
КонецПроцедуры


Процедура ПриКопировании(ОбъектКопирования)
	Ответственный = ПараметрыСеанса.ТекущийПользователь;
	Состояние = Перечисления.скEDI_СостоянияДополнительныхЭлектронныхДокументовДФС.Создан;
	ИмяФайлаДФС = "";
	КтоОформилЗапрос = Неопределено;
	Подписи.Очистить();
	ВыпискаСписокВыданыеДокументы.Очистить();
	ВыпискаСписокПолученыеДокументы.Очистить();
	ДатаОтправки = Неопределено;
	ДатаПолученияОтвета = Неопределено;
	ПричинаОтклоненияДФС = "";
КонецПроцедуры

Функция УдалитьЛидирующиеНулиИНН(Знач ИНН)
	ИНН = СокрЛП(ИНН);
	Пока Лев(ИНН, 1) = "0" Цикл
		ИНН = Сред(ИНН, 2);
	КонецЦикла;
	Возврат ИНН;
КонецФункции

Функция ЗагрузитьВытяг(ОрганизацияПолучатель, ДанныеДокумента, УзелDECLARHEAD, УзелDECLARBODY, ДатаСобытия) Экспорт
	тДатаВитягу = "";
	тВремяВитягу = "";
	Для Каждого ДочернийУзелDECLARBODY Из УзелDECLARBODY.ДочерниеУзлы Цикл
		ФлагЗначениеПолучено = Ложь;
		НомерСтрокиТабличнойЧасти = "";
		ИмяТабличнойЧасти = "";
		ИмяРеквизитаТабличнойЧасти = "";
		ЗначениеРеквизита = Неопределено;
		
		Если ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("HDATE") Тогда
			тДатаВитягу = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("HTIME") Тогда
			тВремяВитягу = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
		/////////////////////////////////
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T1RXXXXG2D") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокПолученыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "ДатаРегистрацииДокумента";
			тДата = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			дГод = 0;
			дМесяц = 0;
			дДень = 0;
			Если скEDI_ОбщегоНазначения.ПолучитьГодМесяцДеньИзДатыФорматаДДММГГГГ(тДата, дГод, дМесяц, дДень) Тогда
				ЗначениеРеквизита = Дата(дГод, дМесяц, дДень);
				ФлагЗначениеПолучено = Истина;
			КонецЕсли;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T1RXXXXG31") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокПолученыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "НомерДокумента";
			ЗначениеРеквизита = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			ФлагЗначениеПолучено = Истина;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T1RXXXXG32") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокПолученыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "СпецРежимНалогообложения";
			ЗначениеРеквизита = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			ФлагЗначениеПолучено = Истина;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T1RXXXXG33") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокПолученыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "Филиал";
			ЗначениеРеквизита = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			ФлагЗначениеПолучено = Истина;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T1RXXXXG4D") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокПолученыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "ДатаДокумента";
			тДата = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			дГод = 0;
			дМесяц = 0;
			дДень = 0;
			Если скEDI_ОбщегоНазначения.ПолучитьГодМесяцДеньИзДатыФорматаДДММГГГГ(тДата, дГод, дМесяц, дДень) Тогда
				ЗначениеРеквизита = Дата(дГод, дМесяц, дДень);
				ФлагЗначениеПолучено = Истина;
			КонецЕсли;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T1RXXXXG5S") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокПолученыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "ВидДокумента";
			ЗначениеРеквизита = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			ФлагЗначениеПолучено = Истина;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T1RXXXXG6") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокПолученыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "ИННПродавца";
			ЗначениеРеквизита = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			ФлагЗначениеПолучено = Истина;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T1RXXXXG6A") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокПолученыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "ИННПродавцаА";
			ЗначениеРеквизита = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			ФлагЗначениеПолучено = Истина;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T1RXXXXG7") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокПолученыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "СуммаНДС";
			тЧисло = СокрЛП(ДочернийУзелDECLARBODY.ТекстовоеСодержимое);
			Если тЧисло <> "" Тогда
				ЗначениеРеквизита = Число(тЧисло);
				ФлагЗначениеПолучено = Истина;
			КонецЕсли;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T1RXXXXG8S") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокПолученыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "ФИООтветственного";
			ЗначениеРеквизита = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			ФлагЗначениеПолучено = Истина;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T1RXXXXG9") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокПолученыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "РегистрационныйНомерДокумента";
			ЗначениеРеквизита = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			ФлагЗначениеПолучено = Истина;
		/////////////////////////////////
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T2RXXXXG2D") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокВыданыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "ДатаРегистрацииДокумента";
			тДата = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			дГод = 0;
			дМесяц = 0;
			дДень = 0;
			Если скEDI_ОбщегоНазначения.ПолучитьГодМесяцДеньИзДатыФорматаДДММГГГГ(тДата, дГод, дМесяц, дДень) Тогда
				ЗначениеРеквизита = Дата(дГод, дМесяц, дДень);
				ФлагЗначениеПолучено = Истина;
			КонецЕсли;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T2RXXXXG31") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокВыданыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "НомерДокумента";
			ЗначениеРеквизита = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			ФлагЗначениеПолучено = Истина;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T2RXXXXG32") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокВыданыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "СпецРежимНалогообложения";
			ЗначениеРеквизита = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			ФлагЗначениеПолучено = Истина;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T2RXXXXG33") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокВыданыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "Филиал";
			ЗначениеРеквизита = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			ФлагЗначениеПолучено = Истина;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T2RXXXXG4D") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокВыданыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "ДатаДокумента";
			тДата = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			дГод = 0;
			дМесяц = 0;
			дДень = 0;
			Если скEDI_ОбщегоНазначения.ПолучитьГодМесяцДеньИзДатыФорматаДДММГГГГ(тДата, дГод, дМесяц, дДень) Тогда
				ЗначениеРеквизита = Дата(дГод, дМесяц, дДень);
				ФлагЗначениеПолучено = Истина;
			КонецЕсли;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T2RXXXXG5S") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокВыданыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "ВидДокумента";
			ЗначениеРеквизита = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			ФлагЗначениеПолучено = Истина;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T2RXXXXG6") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокВыданыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "ИННПродавца";
			ЗначениеРеквизита = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			ФлагЗначениеПолучено = Истина;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T2RXXXXG6A") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокВыданыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "ИННПродавцаА";
			ЗначениеРеквизита = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			ФлагЗначениеПолучено = Истина;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T2RXXXXG7") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокВыданыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "СуммаНДС";
			тЧисло = СокрЛП(ДочернийУзелDECLARBODY.ТекстовоеСодержимое);
			Если тЧисло <> "" Тогда
				ЗначениеРеквизита = Число(тЧисло);
				ФлагЗначениеПолучено = Истина;
			КонецЕсли;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T2RXXXXG8S") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокВыданыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "ФИООтветственного";
			ЗначениеРеквизита = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			ФлагЗначениеПолучено = Истина;
		ИначеЕсли ВРег(ДочернийУзелDECLARBODY.ИмяУзла) = ВРег("T2RXXXXG9") Тогда
			ИмяТабличнойЧасти = "ВыпискаСписокВыданыеДокументы";
			ИмяРеквизитаТабличнойЧасти = "РегистрационныйНомерДокумента";
			ЗначениеРеквизита = ДочернийУзелDECLARBODY.ТекстовоеСодержимое;
			ФлагЗначениеПолучено = Истина;
		КонецЕсли;
		
		Если ФлагЗначениеПолучено Тогда
			Для Каждого АтрибутУзла Из ДочернийУзелDECLARBODY.Атрибуты Цикл
				Если ВРег(АтрибутУзла.Имя) = ВРег("ROWNUM") Тогда
					НомерСтрокиТабличнойЧасти = Число(АтрибутУзла.Значение);
				КонецЕсли;
			КонецЦикла;
			
			ТабличнаяЧастьДокумента = ЭтотОбъект[ИмяТабличнойЧасти];
			Пока ТабличнаяЧастьДокумента.Количество() < НомерСтрокиТабличнойЧасти Цикл
				ТабличнаяЧастьДокумента.Добавить();
			КонецЦикла;
			СтрокаТабличнойЧасти = ТабличнаяЧастьДокумента.Получить(НомерСтрокиТабличнойЧасти-1);
			СтрокаТабличнойЧасти[ИмяРеквизитаТабличнойЧасти] = ЗначениеРеквизита;
		КонецЕсли;
	КонецЦикла;
	
	дГод = 0;
	дМесяц = 0;
	дДень = 0;
	Если скEDI_ОбщегоНазначения.ПолучитьГодМесяцДеньИзДатыФорматаДДММГГГГ(тДатаВитягу, дГод, дМесяц, дДень) Тогда
		дЧас = 0;
		дМинута = 0;
		дСекунда = 0;
		Если скEDI_ОбщегоНазначения.ПолучитьВремяФорматаЧЧММСС(тВремяВитягу, дЧас, дМинута, дСекунда) Тогда
			ДатаВремяВитягу = Дата(дГод, дМесяц, дДень, дЧас, дМинута, дСекунда);
		Иначе
			Возврат Ложь;
		КонецЕсли;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	ДатаФормированияОтвета = ДатаВремяВитягу;
	ДатаПолученияОтвета = ДатаСобытия;
	Состояние = Перечисления.скEDI_СостоянияДополнительныхЭлектронныхДокументовДФС.ПолученоОтветОтДФС;
	
	лМассивПодписей = скEDI_ОбщегоНазначения.ПолучитьМассивПодписейИзМассиваСоответствий(ДанныеДокумента.Получить("Signers"));
	//ИнформацияОПолученомДокументе = ИнформацияОПолученомДокументе + "
	//		|
	//		|Підписи:";
	//ДополнитьОписаниеДаннымиПоПодписямКонтрагента(лМассивПодписей, ИнформацияОПолученомДокументе, Неопределено, Ложь, Ложь);
	лМассивДанныхПоПодписямКонтрагента = скEDI_ОбщегоНазначения.СформироватьМассивДанныхПоПодписямКонтрагента(лМассивПодписей);
	Для Каждого лИнформацияОПодписи Из лМассивДанныхПоПодписямКонтрагента Цикл
		лНоваяСтрокаПодписиКонтрагента = ПодписиКонтрагента.Добавить();
		ЗаполнитьЗначенияСвойств(лНоваяСтрокаПодписиКонтрагента, лИнформацияОПодписи);
	КонецЦикла;
	
	Записать();
	
	скEDI_ВнешниеХранилища.СохранитьСодержимоеДополнительногоЭлектронногоДокументаДФС(Ссылка, Перечисления.скEDI_ТипыСодержимогоДополнительныхЭлектронныхДокуметовДФС.Ответ, ДанныеДокумента.Получить("Body"), "", ДатаСобытия);
	//СодержимоеЭлектронныхДокументовМенеджерЗаписи = РегистрыСведений.скEDI_СодержимоеДополнительныхЭлектронныхДокументовДФС.СоздатьМенеджерЗаписи();
	//СодержимоеЭлектронныхДокументовМенеджерЗаписи.ЭлектронныйДокумент = Ссылка;
	//СодержимоеЭлектронныхДокументовМенеджерЗаписи.ТипСодержимого = Перечисления.скEDI_ТипыСодержимогоДополнительныхЭлектронныхДокуметовДФС.Ответ;
	//СодержимоеЭлектронныхДокументовМенеджерЗаписи.ТелоДокумента = ДанныеДокумента.Получить("Body");
	//СодержимоеЭлектронныхДокументовМенеджерЗаписи.ИзображениеДокумента = "";
	//СодержимоеЭлектронныхДокументовМенеджерЗаписи.Дата = ДатаСобытия;
	//СодержимоеЭлектронныхДокументовМенеджерЗаписи.Записать(Истина);
	
	Если Состояние = Перечисления.скEDI_СостоянияДополнительныхЭлектронныхДокументовДФС.ПолученоОтветОтДФС Тогда
		Если ИмпортДокументаСКвитанцией Тогда
			Для Каждого СтрокаВыписки Из ВыпискаСписокПолученыеДокументы Цикл
				ДатыРегистрацииВЕРННМенеджерЗаписи = РегистрыСведений.скEDI_УстановкаДатыРегистрацииВЕРНН_Выписка.СоздатьМенеджерЗаписи();
				ДатыРегистрацииВЕРННМенеджерЗаписи.Организация = ОрганизацияПолучатель;
				ДатыРегистрацииВЕРННМенеджерЗаписи.ЭлектронныйДокументВыписка = Ссылка;
				ДатыРегистрацииВЕРННМенеджерЗаписи.ВхИсх = Перечисления.скEDI_ВхИсхЭлектронныйДокумент.Входящий;
				Если ВРег(СтрокаВыписки.ВидДокумента) = "ПН" Тогда
					ДатыРегистрацииВЕРННМенеджерЗаписи.ТипДокумента = Перечисления.скEDI_ТипыЭлектронныхДокументов.НалоговаяНакладная;
				ИначеЕсли ВРег(СтрокаВыписки.ВидДокумента) = "РК" Тогда
					ДатыРегистрацииВЕРННМенеджерЗаписи.ТипДокумента = Перечисления.скEDI_ТипыЭлектронныхДокументов.Приложение2КНалоговойНакладной;
				Иначе
					Продолжить;
				КонецЕсли;
				ДатыРегистрацииВЕРННМенеджерЗаписи.НомерДокумента = СтрокаВыписки.НомерДокумента;
				ДатыРегистрацииВЕРННМенеджерЗаписи.СпецРежимНалогообложения = СтрокаВыписки.СпецРежимНалогообложения;
				ДатыРегистрацииВЕРННМенеджерЗаписи.Филиал = СтрокаВыписки.Филиал;
				ДатыРегистрацииВЕРННМенеджерЗаписи.ДатаДокумента = СтрокаВыписки.ДатаДокумента;
				ДатыРегистрацииВЕРННМенеджерЗаписи.ИННПродавца = УдалитьЛидирующиеНулиИНН(СтрокаВыписки.ИННПродавца);
				ДатыРегистрацииВЕРННМенеджерЗаписи.ДатаРегистрацииДокумента = СтрокаВыписки.ДатаРегистрацииДокумента;
				ДатыРегистрацииВЕРННМенеджерЗаписи.РегистрационныйНомерДокумента = СтрокаВыписки.РегистрационныйНомерДокумента;
				ДатыРегистрацииВЕРННМенеджерЗаписи.ДатаПолучения = ДатаСобытия;
				ДатыРегистрацииВЕРННМенеджерЗаписи.Записать(Истина);
			КонецЦикла;
			Для Каждого СтрокаВыписки Из ВыпискаСписокВыданыеДокументы Цикл
				ДатыРегистрацииВЕРННМенеджерЗаписи = РегистрыСведений.скEDI_УстановкаДатыРегистрацииВЕРНН_Выписка.СоздатьМенеджерЗаписи();
				ДатыРегистрацииВЕРННМенеджерЗаписи.Организация = ОрганизацияПолучатель;
				ДатыРегистрацииВЕРННМенеджерЗаписи.ЭлектронныйДокументВыписка = Ссылка;
				ДатыРегистрацииВЕРННМенеджерЗаписи.ВхИсх = Перечисления.скEDI_ВхИсхЭлектронныйДокумент.Исходящий;
				Если ВРег(СтрокаВыписки.ВидДокумента) = "ПН" Тогда
					ДатыРегистрацииВЕРННМенеджерЗаписи.ТипДокумента = Перечисления.скEDI_ТипыЭлектронныхДокументов.НалоговаяНакладная;
				ИначеЕсли ВРег(СтрокаВыписки.ВидДокумента) = "РК" Тогда
					ДатыРегистрацииВЕРННМенеджерЗаписи.ТипДокумента = Перечисления.скEDI_ТипыЭлектронныхДокументов.Приложение2КНалоговойНакладной;
				Иначе
					Продолжить;
				КонецЕсли;
				ДатыРегистрацииВЕРННМенеджерЗаписи.НомерДокумента = СтрокаВыписки.НомерДокумента;
				ДатыРегистрацииВЕРННМенеджерЗаписи.СпецРежимНалогообложения = СтрокаВыписки.СпецРежимНалогообложения;
				ДатыРегистрацииВЕРННМенеджерЗаписи.Филиал = СтрокаВыписки.Филиал;
				ДатыРегистрацииВЕРННМенеджерЗаписи.ДатаДокумента = СтрокаВыписки.ДатаДокумента;
				ДатыРегистрацииВЕРННМенеджерЗаписи.ИННПродавца = УдалитьЛидирующиеНулиИНН(СтрокаВыписки.ИННПродавца);
				ДатыРегистрацииВЕРННМенеджерЗаписи.ДатаРегистрацииДокумента = СтрокаВыписки.ДатаРегистрацииДокумента;
				ДатыРегистрацииВЕРННМенеджерЗаписи.РегистрационныйНомерДокумента = СтрокаВыписки.РегистрационныйНомерДокумента;
				ДатыРегистрацииВЕРННМенеджерЗаписи.ДатаПолучения = ДатаСобытия;
				ДатыРегистрацииВЕРННМенеджерЗаписи.Записать(Истина);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	Возврат Истина;
КонецФункции
