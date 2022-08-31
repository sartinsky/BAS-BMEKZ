////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

// Устанавливает видимость элементов формы в зависимости от выбранного способа начисления амортизации
// в бухгалтерском учете
//
&НаСервере
Процедура УстановитьВидимостьПараметровАмортизацииБУ()
	
	СпособыНачисленияАмортизации = Перечисления.СпособыНачисленияАмортизацииОС;
	
	ЭтаФорма.Элементы.НачислятьАмортизациюБУ.Видимость = (СпособНачисленияАмортизацииБУ <> СпособыНачисленияАмортизации._100)
	                                   И (СпособНачисленияАмортизацииБУ <> СпособыНачисленияАмортизации._50_50);

	ЭтаФорма.Элементы.ГруппаАмортизацияПроизводственный.Видимость = Ложь;								   
	ЭтаФорма.Элементы.ГруппаАмортизацияПрочие.Видимость = Ложь;								   
									   
	Если СпособНачисленияАмортизацииБУ = СпособыНачисленияАмортизации.Производственный Тогда
		
		ЭтаФорма.Элементы.ГруппаАмортизацияПроизводственный.Видимость = Истина;								   
		
		ДатаНКУ2015_ДляВводаНачальныхОстатков = '2015 01 01' - 86400;
		ЭтоДокументДо2015 = (Дата < ДатаНКУ2015_ДляВводаНачальныхОстатков);
		
		ВидимостьСрокПолезногоИспользованияНУ = Ложь;
		Если ЭтоДокументДо2015 Тогда
		Иначе	
			Если 	(СпособНачисленияАмортизацииНУ = Перечисления.СпособыНачисленияАмортизацииОС.Прямолинейный)
			  ИЛИ (СпособНачисленияАмортизацииНУ = Перечисления.СпособыНачисленияАмортизацииОС.УменьшенияОстатка)
			  ИЛИ (СпособНачисленияАмортизацииНУ = Перечисления.СпособыНачисленияАмортизацииОС.Кумулятивный)
			  ИЛИ (СпособНачисленияАмортизацииНУ = Перечисления.СпособыНачисленияАмортизацииОС.УскоренногоУменьшенияОстатка) Тогда
	      	ВидимостьСрокПолезногоИспользованияНУ = Истина;
			ЭтаФорма.Элементы.ГруппаАмортизацияПрочие.Видимость = Истина;								   
			КонецЕсли;
		КонецЕсли;	
		
		ЭтаФорма.Элементы.ГруппаСрокИспользованияБУ.Видимость = Ложь;
		
		ЭтаФорма.Элементы.ГруппаСрокИспользованияНУ.Видимость 		= ВидимостьСрокПолезногоИспользованияНУ;
		ЭтаФорма.Элементы.ГрафикАмортизацииБУ.Видимость 			= ВидимостьСрокПолезногоИспользованияНУ;
		ЭтаФорма.Элементы.ДатаВводаВЭксплуатациюРеглБУ.Видимость 	= ВидимостьСрокПолезногоИспользованияНУ;
		
	ИначеЕсли (СпособНачисленияАмортизацииБУ = СпособыНачисленияАмортизации.Прямолинейный)
		  ИЛИ (СпособНачисленияАмортизацииБУ = СпособыНачисленияАмортизации.УменьшенияОстатка)
		  ИЛИ (СпособНачисленияАмортизацииБУ = СпособыНачисленияАмортизации.Кумулятивный)
		  ИЛИ (СпособНачисленияАмортизацииБУ = СпособыНачисленияАмортизации.УскоренногоУменьшенияОстатка) Тогда
		
		ЭтаФорма.Элементы.ГруппаАмортизацияПрочие.Видимость = Истина;								   
		ЭтаФорма.Элементы.ГруппаСрокИспользованияБУ.Видимость = Истина;
		ЭтаФорма.Элементы.ГруппаСрокИспользованияНУ.Видимость = Истина;

		ЭтаФорма.Элементы.ЛиквидационнаяСтоимостьБУ.ОтметкаНезаполненного = ((ЛиквидационнаяСтоимостьБУ = 0)
		                                                                  И (СпособНачисленияАмортизацииБУ 
		                                                                     = Перечисления.СпособыНачисленияАмортизацииОС.УменьшенияОстатка));

		ЭтаФорма.Элементы.ДатаВводаВЭксплуатациюРеглБУ.Видимость =  СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.УменьшенияОстатка 
																ИЛИ СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.УскоренногоУменьшенияОстатка
																ИЛИ СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.Кумулятивный
																ИЛИ СпособНачисленияАмортизацииНУ = Перечисления.СпособыНачисленияАмортизацииОС.УменьшенияОстатка 
																ИЛИ СпособНачисленияАмортизацииНУ = Перечисления.СпособыНачисленияАмортизацииОС.УскоренногоУменьшенияОстатка
																ИЛИ СпособНачисленияАмортизацииНУ = Перечисления.СпособыНачисленияАмортизацииОС.Кумулятивный
																;
	КонецЕсли;
	
КонецПроцедуры

// Процедура добавляет к надписи "мес." расшифровку срока полезного использования
// в годах и месяцах.
// 
Процедура УстановитьРасшифровкуСрокаПолезногоИспользования(СрокПолезногоИспользования, ЭлементФормы)
	
	РасшифровкаСрокаПолезногоИспользования = "";
	
	Если ЗначениеЗаполнено(СрокПолезногоИспользования) Тогда
	
		ЧислоЛет     = Цел(СрокПолезногоИспользования / 12);
		ЧислоМесяцев = (СрокПолезногоИспользования % 12);
		
		Если НЕ (ЧислоЛет = 0) Тогда
			
			// Построим строку с числом лет
			Если (СтрДлина(ЧислоЛет) > 1) И (Число(Сред(ЧислоЛет, СтрДлина(ЧислоЛет) - 1, 1)) = 1) Тогда
				СтрокаГод = НСтр("ru=' лет';uk=' років'");
			ИначеЕсли Число(Прав(ЧислоЛет, 1)) = 1 Тогда
				СтрокаГод = НСтр("ru=' год';uk=' рік'");
			ИначеЕсли (Число(Прав(ЧислоЛет, 1)) > 1) И (Число(Прав(ЧислоЛет, 1)) < 5) Тогда
				СтрокаГод = НСтр("ru=' года';uk=' року'");
			Иначе
				СтрокаГод = НСтр("ru=' лет';uk=' років'");
			КонецЕсли;
			
			РасшифровкаСрокаПолезногоИспользования = РасшифровкаСрокаПолезногоИспользования + Строка(ЧислоЛет) + СтрокаГод;
			
		КонецЕсли;
		
		Если НЕ (ЧислоМесяцев = 0) Тогда
			
			// Построим строку с числом месяцев
			Если (СтрДлина(ЧислоМесяцев) > 1) И (Число(Сред(ЧислоМесяцев, СтрДлина(ЧислоМесяцев) - 1, 1)) = 1) Тогда
				СтрокаМесяц = НСтр("ru=' месяцев';uk=' місяців'");
			ИначеЕсли Число(Прав(ЧислоМесяцев, 1)) = 1 Тогда
				СтрокаМесяц = НСтр("ru=' месяц';uk=' місяць'");
			ИначеЕсли (Число(Прав(ЧислоМесяцев, 1)) > 1) И (Число(Прав(ЧислоМесяцев, 1)) < 5) Тогда
				СтрокаМесяц = НСтр("ru=' месяца';uk=' місяця'");
			Иначе
				СтрокаМесяц = НСтр("ru=' месяцев';uk=' місяців'");
			КонецЕсли;
			
			РасшифровкаСрокаПолезногоИспользования = РасшифровкаСрокаПолезногоИспользования + ?(НЕ ЗначениеЗаполнено(РасшифровкаСрокаПолезногоИспользования), "", " ") + Строка(ЧислоМесяцев) + СтрокаМесяц;
		
		КонецЕсли;
		
		РасшифровкаСрокаПолезногоИспользования = "(" + РасшифровкаСрокаПолезногоИспользования + ")";
		
	КонецЕсли;
	
	ЭлементФормы.Заголовок = РасшифровкаСрокаПолезногоИспользования;
	                                        	
КонецПроцедуры // УстановитьРасшифровкуСрокаПолезногоИспользования()


/////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	мДатаУчетнойПолитики = КонецМесяца(Форма.Дата) + 1;
	
	// Установка видимости надписи с расшифровкой сроков полезного использования и использованного.
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияБУ(Форма);
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияНУ(Форма);
	
	ДатаНКУ2015_ДляВводаНачальныхОстатков = '2015 01 01' - 86400;
	ЭтоДокументДо2015 = (Форма.Дата < ДатаНКУ2015_ДляВводаНачальныхОстатков);
	
	Форма.Элементы.ДатаВводаВЭксплуатациюРегл.Доступность =  НЕ (Форма.СпособНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.УменьшенияОстатка") 
											  ИЛИ Форма.СпособНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.УскоренногоУменьшенияОстатка")
											  ИЛИ Форма.СпособНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.Кумулятивный"));
											  
	Форма.Элементы.БалансоваяСтоимостьНУ.Видимость = Форма.ЕстьНалогНаПрибыль;	
	Форма.Элементы.НакопленнаяАмортизацияНУ.Видимость = Форма.ЕстьНалогНаПрибыль;
	Форма.Элементы.СрокИспользованияДляВычисленияАмортизацииНУ.Видимость = Форма.ЕстьНалогНаПрибыль;
	Форма.Элементы.РасшифровкаСрокаПолезногоИспользованияНУ.Видимость = Форма.ЕстьНалогНаПрибыль;

	НепроизводственноеНУ = Форма.НепроизводственноеНУ;
	
	Форма.Элементы.СпособНачисленияАмортизацииНУ.Видимость = НЕ ЭтоДокументДо2015 И НЕ НепроизводственноеНУ;
	Форма.Элементы.БалансоваяСтоимостьНУ.Видимость 		= НЕ ЭтоДокументДо2015 И НЕ НепроизводственноеНУ;
	Форма.Элементы.НакопленнаяАмортизацияНУ.Видимость 	= НЕ ЭтоДокументДо2015 И НЕ НепроизводственноеНУ;
	
	Форма.Элементы.ГруппаСрокИспользованияНУ.Видимость = НЕ НепроизводственноеНУ;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПересчитатьСуммыРазниц(Форма)
	
	
КонецПроцедуры // ПересчитатьСуммыРазниц()

&НаКлиенте
Процедура ОчиститьНеиспользуемыеРеквизиты()
	
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияБУ(ЭтаФорма);
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияНУ(ЭтаФорма);
				
КонецПроцедуры // ОчиститьНеиспользуемыеРеквизиты()

&НаКлиенте
Процедура ЗаполнитьИспользуемыеРеквизитыНУ()
	
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОтобразитьРасшифровкуСрокаПолезногоИспользованияБУ(Форма)
	
	Форма.Элементы.РасшифровкаСрокаПолезногоИспользованияБУ.Заголовок = 
		УправлениеВнеоборотнымиАктивамиКлиентСервер.РасшифровкаСрокаПолезногоИспользования(Форма.СрокИспользованияДляВычисленияАмортизацииБУ);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОтобразитьРасшифровкуСрокаПолезногоИспользованияНУ(Форма)
	
	Форма.Элементы.РасшифровкаСрокаПолезногоИспользованияНУ.Заголовок = 
		УправлениеВнеоборотнымиАктивамиКлиентСервер.РасшифровкаСрокаПолезногоИспользования(Форма.СрокИспользованияДляВычисленияАмортизацииНУ);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПолучитьИнвентарныйНомер(СтруктураПолей)
	
	Если ЗначениеЗаполнено(СтруктураПолей.ОсновноеСредство) Тогда
		СтруктураПолей.ИнвентарныйНомерРегл = СтруктураПолей.ОсновноеСредство.Код;
	Иначе
		СтруктураПолей.ИнвентарныйНомерРегл = "";
	КонецЕсли;	

КонецПроцедуры

&НаСервере
Функция ВернутьСтруктуруЗакрытия()
	
	Структура = Новый Структура();
	
	Для Каждого Реквизит Из ЭтаФорма.ПолучитьРеквизиты() Цикл
		Структура.Вставить(Реквизит.Имя, ЭтаФорма[Реквизит.Имя]);
	КонецЦикла;
	
	Структура.Вставить("СрокПолезногоИспользованияБУ",ЭтаФорма.СрокИспользованияДляВычисленияАмортизацииБУ);
	
	Возврат Структура;
	
КонецФункции

&НаКлиенте
Процедура ВопросСохранитьИзмененияЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		Если ПроверитьЗаполнение() Тогда
			Модифицированность = Ложь;
			РезультатЗакрытия = ВернутьСтруктуруЗакрытия();
			Закрыть(РезультатЗакрытия);
		КонецЕсли;
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть(Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросОчищениеГрафикаАмортизацииЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.ОК Тогда
		ГрафикАмортизацииБУ = Неопределено;
	Иначе
		СезонныйХарактерПроизводства = Истина;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

// Функция возвращает список значений доступных способов амортизации для бух. учета
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   СписокЗначений
//
&НаСервереБезКонтекста
Функция ПолучитьМассивСпособовАмортизацииБУ(СчетУчетаБУ) Экспорт
                                                                                                        
	МассивПеречисления = Новый Массив;
	
	МассивПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.Прямолинейный);
	МассивПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.Производственный);
	
	Если ЗначениеЗаполнено(СчетУчетаБУ) 
		  И СчетУчетаБУ.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.ДругиеНеоборотныеМатериальныеАктивыГруппа) Тогда
		  
		Если СчетУчетаБУ.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.БиблиотечныеФонды)
		 ИЛИ СчетУчетаБУ.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.МалоценныеНеоборотныеМатериальныеАктивы) Тогда
			
			МассивПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС._50_50);
			МассивПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС._100);
			
		КонецЕсли;
		  
	Иначе
	
		МассивПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.УменьшенияОстатка);
		МассивПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.УскоренногоУменьшенияОстатка);
		МассивПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.Кумулятивный);
		
	КонецЕсли;
	
	Возврат МассивПеречисления;

КонецФункции // ПолучитьМассивСпособовАмортизацииБУ()

// Функция возвращает список значений доступных способов амортизации для нал. учета
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   СписокЗначений
//
&НаСервереБезКонтекста
Функция ПолучитьМассивСпособовАмортизацииНУ(СчетУчетаБУ, СпособНачисленияАмортизацииБУ, ДатаВводаНачальныхОстатков) Экспорт

                                                                                                        
	МассивПеречисления = Новый Массив;
	
	Если СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС._50_50 ИЛИ СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС._100 Тогда
		МассивПеречисления.Добавить(СпособНачисленияАмортизацииБУ);
		Возврат МассивПеречисления;
	КонецЕсли;	
	
	МассивПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.Прямолинейный);
	Если ДатаВводаНачальныхОстатков >= Дата('20200301') 
			И СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.Производственный Тогда
		МассивПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.Производственный);	
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(СчетУчетаБУ) 
		  И НЕ СчетУчетаБУ.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.ДругиеНеоборотныеМатериальныеАктивыГруппа) Тогда
		МассивПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.УменьшенияОстатка);
		МассивПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.УскоренногоУменьшенияОстатка);
		МассивПеречисления.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.Кумулятивный);
				
	КонецЕсли;
	
	Возврат МассивПеречисления;

КонецФункции // ПолучитьМассивСпособовАмортизацииНУ()

// Устанавливает СчетНачисленияАмортизацииБУ 
// по значению СчетУчетаБУ 
//
&НаСервереБезКонтекста
Процедура УстановитьСчетАмортизации(СчетУчетаБУ,СчетАмортизацииБУ)
	
	ПланХозрасчетный = ПланыСчетов.Хозрасчетный;
	
	Счет10   = ПланХозрасчетный.ОсновныеСредства;
	Счет11   = ПланХозрасчетный.ДругиеНеоборотныеМатериальныеАктивыГруппа;
	Счет13   = ПланХозрасчетный.ИзносАмортизацияНеоборотныхАктивов;
	Счет131  = ПланХозрасчетный.ИзносОсновныхСредств;
	Счет132  = ПланХозрасчетный.ИзносДругихНеоборотныхМатериальныхАктивов;
	Счет1321 = ПланХозрасчетный.ИзносДругихНеоборотныхМатериальныхАктивовИндивидуально;
	Счет1322 = ПланХозрасчетный.ИзносДругихНеоборотныхМатериальныхАктивовКоличественно;
	Счет151  = ПланХозрасчетный.КапитальноеСтроительство;
	Счет152  = ПланХозрасчетный.ПриобретениеИзготовлениеОсновныхСредств;
	Счет153  = ПланХозрасчетный.ПриобретениеИзготовлениеДругихНеоборотныхМатериальныхАктивов;
	
	Если ЗначениеЗаполнено(СчетУчетаБУ) Тогда
		
		Если СчетУчетаБУ.ПринадлежитЭлементу(Счет10) Тогда
			
			Если НЕ ЗначениеЗаполнено(СчетАмортизацииБУ)
				ИЛИ (НЕ СчетАмортизацииБУ.ПринадлежитЭлементу(Счет13))
				ИЛИ СчетАмортизацииБУ.ПринадлежитЭлементу(Счет132) Тогда
				
				СчетАмортизацииБУ = Счет131;
				
			КонецЕсли;
			
		ИначеЕсли СчетУчетаБУ.ПринадлежитЭлементу(Счет11) Тогда
			
			Если НЕ ЗначениеЗаполнено(СчетАмортизацииБУ)
				ИЛИ (НЕ СчетАмортизацииБУ.ПринадлежитЭлементу(Счет132))
				ИЛИ СчетАмортизацииБУ = (Счет1322) Тогда
				
				СчетАмортизацииБУ = Счет1321;
				
			КонецЕсли;                                                   
			
		КонецЕсли;
		
	КонецЕсли;
		

КонецПроцедуры // УстановитьСчетАмортизации()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
		
	Если ПроверитьЗаполнение() Тогда
		Модифицированность = Ложь;
		РезультатЗакрытия = ВернутьСтруктуруЗакрытия();
		Закрыть(РезультатЗакрытия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьБезПроверок(Команда)
	Модифицированность = Ложь;
	РезультатЗакрытия = ВернутьСтруктуруЗакрытия();
	Закрыть(РезультатЗакрытия);
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура ОсновноеСредствоПриИзменении(Элемент)
		
	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить("ОсновноеСредство", ОсновноеСредство);
	СтруктураПолей.Вставить("ИнвентарныйНомерРегл", ИнвентарныйНомерРегл);	
	ПолучитьИнвентарныйНомер(СтруктураПолей);
	ИнвентарныйНомерРегл = СтруктураПолей.ИнвентарныйНомерРегл;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ЗАКЛАДКИ "УЧЕТНЫЕ ДАННЫЕ"

&НаКлиенте
Процедура СчетУчетаБУПриИзменении(Элемент)
	
	МассивСпособовНачисленияАмортизацииБУ = ПолучитьМассивСпособовАмортизацииБУ(СчетУчетаБУ);
	
	Если НЕ ЗначениеЗаполнено(СпособНачисленияАмортизацииБУ)
	 ИЛИ МассивСпособовНачисленияАмортизацииБУ.Найти(СпособНачисленияАмортизацииБУ) = Неопределено Тогда
	 
		МассивНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.Прямолинейный");
		УстановитьВидимостьПараметровАмортизацииБУ();
		
	КонецЕсли;                                                                                    
	
	Элементы.СпособНачисленияАмортизацииБУ.СписокВыбора.ЗагрузитьЗначения(МассивСпособовНачисленияАмортизацииБУ);
	УстановитьСчетАмортизации(СчетУчетаБУ,СчетАмортизацииБУ);
	
	МассивСпособовНачисленияАмортизацииНУ = ПолучитьМассивСпособовАмортизацииНУ(СчетУчетаБУ, СпособНачисленияАмортизацииБУ,ЭтаФорма.Дата);

	Если НЕ ЗначениеЗаполнено(СпособНачисленияАмортизацииНУ)
			ИЛИ МассивСпособовНачисленияАмортизацииНУ.Найти(СпособНачисленияАмортизацииНУ) = Неопределено Тогда
	 
		МассивНачисленияАмортизацииНУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.Прямолинейный");
		
	КонецЕсли;                                                                                    
	
	Элементы.СпособНачисленияАмортизацииНУ.СписокВыбора.ЗагрузитьЗначения(МассивСпособовНачисленияАмортизацииНУ);

	УправлениеНеоборотнымиАктивами.УстановитьНалоговуюГруппуОС(СчетУчетаБУ, НалоговаяГруппаОС);
	
	УстановитьВидимостьПараметровАмортизацииБУ();

КонецПроцедуры

&НаКлиенте
Процедура СпособНачисленияАмортизацииБУПриИзменении(Элемент)
	
	Если (СпособНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС._50_50"))
			ИЛИ (СпособНачисленияАмортизацииБУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС._100")) Тогда 		 
		 НачислятьАмортизациюБУ = Истина;                                                         		
	 КонецЕсли;
	 
	  ДатаВводаНачальныхОстатков = ЭтаФорма.Дата;
	  Элементы.СпособНачисленияАмортизацииНУ.СписокВыбора.ЗагрузитьЗначения(ПолучитьМассивСпособовАмортизацииНУ(СчетУчетаБУ, СпособНачисленияАмортизацииБУ,ДатаВводаНачальныхОстатков));
		
	Если ДатаВводаНачальныхОстатков >= Дата('20200301') Тогда
		СпособНачисленияАмортизацииНУ = СпособНачисленияАмортизацииБУ;
	ИначеЕсли СпособНачисленияАмортизацииБУ <> ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.Производственный") Тогда
		СпособНачисленияАмортизацииНУ = СпособНачисленияАмортизацииБУ;
	Иначе	
		СпособНачисленияАмортизацииНУ = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.Прямолинейный");
	КонецЕсли;	
	
	УстановитьВидимостьПараметровАмортизацииБУ();

КонецПроцедуры

&НаКлиенте
Процедура СпособНачисленияАмортизацииНУПриИзменении(Элемент)
	
	УстановитьВидимостьПараметровАмортизацииБУ();

КонецПроцедуры

&НаКлиенте
Процедура ТекущаяСтоимостьБУПриИзменении(Элемент)
	Если НЕ ПервоначальнаяСтоимостьБУ Тогда
		ПервоначальнаяСтоимостьБУ = ТекущаяСтоимостьБУ;    
	КонецЕсли; // НЕ ПервоначальнаяСтоимостьБУ   	
	
	Если БалансоваяСтоимостьНУ = 0 Тогда
		БалансоваяСтоимостьНУ = ТекущаяСтоимостьБУ;    
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияДляВычисленияАмортизацииБУПриИзменении(Элемент)
	СрокИспользованияДляВычисленияАмортизацииНУ = СрокИспользованияДляВычисленияАмортизацииБУ;
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияБУ(ЭтаФорма);
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияНУ(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияДляВычисленияАмортизацииНУПриИзменении(Элемент)
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияНУ(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПревышениеСуммДооценокНадСуммамиУценокБУПриИзменении(Элемент)
	Если СуммаДопКапиталаНачисленногоПриДооценкахОСБУ = 0 Тогда
		СуммаДопКапиталаНачисленногоПриДооценкахОСБУ = ПревышениеСуммДооценокНадСуммамиУценокБУ;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура НалоговоеНазначениеПриИзменении(Элемент)
	НепроизводственноеНУ = ОпределитьНепроизводственноеНУ(НалоговоеНазначение);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОпределитьНепроизводственноеНУ(НалоговоеНазначение)
	Возврат НалоговоеНазначение.ВидНалоговойДеятельности = ПредопределенноеЗначение("Справочник.ВидыНалоговойДеятельности.НеОблагаемая");
КонецФункции

&НаКлиенте
Процедура НакопленнаяАмортизацияБУПриИзменении(Элемент)
	Если НакопленнаяАмортизацияНУ = 0 Тогда
		НакопленнаяАмортизацияНУ = НакопленнаяАмортизацияБУ;
	КонецЕсли;	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ЗАКЛАДКИ "ОБЩИЕ СВЕДЕНИЯ"

&НаКлиенте
Процедура ПервоначальнаяСтоимостьБУПриИзменении(Элемент)
	Если ТекущаяСтоимостьБУ = 0 Тогда
		ТекущаяСтоимостьБУ = ПервоначальнаяСтоимостьБУ;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.ДанныеЗаполнения);
	
	ДатаУчетнойПолитики = КонецМесяца(Дата) + 1;
	ЕстьНалогНаПрибыль = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, ДатаУчетнойПолитики);
	ЕстьНДС            = УчетнаяПолитика.ПлательщикНДС(Организация, ДатаУчетнойПолитики);	
	
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрОрганизацияФункциональныхОпцийФормы(
		ЭтаФорма,
		Организация,
		ДатаУчетнойПолитики);
	
	// Установка значений по умолчанию.
	Если Параметры.ЭтоНовый И НЕ Параметры.Копирование Тогда
		
		СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.Прямолинейный;
		НачислятьАмортизациюБУ        = Истина;
		НачислятьАмортизациюНУ        = Истина;
		СчетУчетаБУ                   = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
		СчетАмортизацииБУ             = ПланыСчетов.Хозрасчетный.ИзносОсновныхСредств;
		СчетУчетаДооценокОС           = ПланыСчетов.Хозрасчетный.ДооценкаОсновныхСредств;
		ПодразделениеОрганизации      = "";
		СобытиеВводаВЭксплуатациюРегл = УправлениеНеоборотнымиАктивами.ПолучитьСобытиеПоОСИзСправочника(Перечисления.ВидыСобытийОС.ВводВЭксплуатацию);
 		НалоговоеНазначение           = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_Облагаемая;
		СчетУчетаКапитала             = ПланыСчетов.Хозрасчетный.ДооценкаОсновныхСредств;
 		ДатаВводаВЭксплуатациюРегл    = ДатаУчетнойПолитики;

	КонецЕсли;
	
	Заголовок = НСтр("ru='Основные средства: %1';uk='Основні засоби: %1'");
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Заголовок,
		?(Параметры.ЭтоНовый, НСтр("ru=': Новая строка';uk=': Новий рядок'"), ОсновноеСредство));
	
	// Ограничение выбора счета учета:
	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.ОсновныеСредства);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.ДругиеНеоборотныеМатериальныеАктивыГруппа);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.НеоборотныеАктивыИГруппыВыбытияУдерживаемыеДляПродажи);
	// ИНАГРО++
	Если ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБСПУ()Тогда
		МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.ДолгосрочныеБиологическиеАктивыРастениеводстваПоПервоначальнойСтоимостиАмортизируются); // 1622 
		МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.ДолгосрочныеБиологическиеАктивыЖивотноводстваПоПервоначальнойСтоимостиАмортизируются); // 1642  
		МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.НезрелыеДолгосрочныеБиологическиеАктивыПоПервоначальнойСтоимостиАмортизируются); // 1662
	КонецЕсли;
	// ИНАГРО-- 
	
	МассивСчетовАмортизации = Новый Массив;
	МассивСчетовАмортизации.Добавить(ПланыСчетов.Хозрасчетный.ИзносАмортизацияНеоборотныхАктивов);
	
	МассивИсключений = Новый Массив;
	МассивИсключений.Добавить(ПланыСчетов.Хозрасчетный.БиблиотечныеФондыКоличественно);
	МассивИсключений.Добавить(ПланыСчетов.Хозрасчетный.МалоценныеНеоборотныеМатериальныеАктивыКоличественно);
	
	мСписокСчетов            = БухгалтерскийУчет.ПолучитьМассивСчетовССубсчетами(МассивСчетов, Ложь, , , МассивИсключений);
	мСписокСчетовАмортизации = БухгалтерскийУчет.ПолучитьМассивСчетовССубсчетами(МассивСчетовАмортизации, Ложь, , , МассивИсключений);
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораСчета(Элементы.СчетУчетаБУ, мСписокСчетов);
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораСчета(Элементы.СчетАмортизацииБУ, мСписокСчетовАмортизации);
	
	ПересчитатьСуммыРазниц(ЭтаФорма);
	
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияБУ(ЭтаФорма);
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияНУ(ЭтаФорма);
	
	мВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();
	Элементы.РеглВалюта.Заголовок = мВалютаРегл;
	
	УстановитьВидимостьПараметровАмортизацииБУ();
	
	Элементы.СпособНачисленияАмортизацииБУ.СписокВыбора.ЗагрузитьЗначения(ПолучитьМассивСпособовАмортизацииБУ(СчетУчетаБУ));
	Элементы.СпособНачисленияАмортизацииНУ.СписокВыбора.ЗагрузитьЗначения(ПолучитьМассивСпособовАмортизацииНУ(СчетУчетаБУ, СпособНачисленияАмортизацииБУ, ЭтаФорма.Дата));
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		ТекстВопроса = НСтр("ru='Данные были изменены. Сохранить изменения?';uk='Дані були змінені. Зберегти зміни?'");
		Оповещение = Новый ОписаниеОповещения("ВопросСохранитьИзмененияЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ОбязательныеРеквизиты = "ОсновноеСредство,
	|ДатаВводаВЭксплуатациюРегл,
	|ПодразделениеОрганизации,
	|ИнвентарныйНомерРегл,
	|СчетУчетаБУ";
	
	НалУчет    = ЕстьНалогНаПрибыль;
	НалУчетОбщ = ЕстьНалогНаПрибыль ИЛИ ЕстьНДС;
	СтрокаОС   = ВернутьСтруктуруЗакрытия();
	
	РеквизитыДляПроверки = Документы.ВводНачальныхОстатков.ПолучитьРеквизитыОСДляПроверки(Дата, СтрокаОС,ОбязательныеРеквизиты, НалУчет, НалУчетОбщ);
	
	ПроверяемыеРеквизиты.Очистить();
	
	Для каждого КлючЗначение Из РеквизитыДляПроверки Цикл
		ПроверяемыеРеквизиты.Добавить(КлючЗначение.Ключ);
	КонецЦикла; 	
	
КонецПроцедуры










