#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда  

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ТипДанныхЗаполнения = Тип("Структура") И ДанныеЗаполнения.Свойство("АдресТаблицаБазисныеЗначенияВХранилище") Тогда
		ЗаполнениеДокументов.ЗаполнитьПоСтруктуре(ЭтотОбъект, ДанныеЗаполнения);
		ЗаполнитьТабличнуюЧасть(ДанныеЗаполнения);
	Иначе
		ИНАГРО_ЭлеваторЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
		ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения); 	
	КонецЕсли;
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры 

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
		   
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);
	
	СтруктураШапкиДокумента = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = ОбщегоНазначенияРед12.СформироватьДеревоПолейЗапросаПоШапке();
	                                          
	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа.
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, "");
		
	// Движения по документу
	Если НЕ Отказ Тогда
		
		Для Каждого СтрокаТабличнойЧасти Из Товары Цикл
			
			Движение = Движения.ИНАГРО_ЗначенияБазисов.Добавить();
			Движение.Период 			          = Дата;
			Движение.Организация 		          = Организация;
			Движение.Контрагент 		          = Контрагент;
			Движение.ДоговорКонтрагента           = ДоговорКонтрагента;
			Движение.Склад                        = Склад;
			Движение.ВидКультуры 		          = СтрокаТабличнойЧасти.ВидКультуры;
			Движение.Влажность			          = СтрокаТабличнойЧасти.Влажность;
			Движение.ВлажностьДляРасчетаУслуг 	  = СтрокаТабличнойЧасти.ВлажностьДляРасчетаУслуг;
			Движение.СорнаяПримесь				  = СтрокаТабличнойЧасти.СорнаяПримесь;
			Движение.СорнаяПримесьДляРасчетаУслуг = СтрокаТабличнойЧасти.СорнаяПримесьДляРасчетаУслуг;
			Движение.ЗерноваяПримесь 			  = СтрокаТабличнойЧасти.ЗерноваяПримесь;
						
		КонецЦикла;
	
	КонецЕсли;	
		
	ПроведениеСервер.ПодготовитьНаборыЗаписейКЗаписиДвижений(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункци

Процедура ЗаполнитьТабличнуюЧасть(Параметры)
	
	АдресТаблицаБазисныеЗначенияВХранилище = "";
	
	Параметры.Свойство("АдресТаблицаБазисныеЗначенияВХранилище", АдресТаблицаБазисныеЗначенияВХранилище);
	
	Если АдресТаблицаБазисныеЗначенияВХранилище <> Неопределено Тогда  
		
		Таблица = ПолучитьИзВременногоХранилища(АдресТаблицаБазисныеЗначенияВХранилище);	
		
		Для Каждого СтрокаТаблицы Из Таблица Цикл
			
			НоваяСтрока = Товары.Добавить();
			НоваяСтрока.ВидКультуры                  = СтрокаТаблицы.ВидКультуры;
			НоваяСтрока.Влажность                    = СтрокаТаблицы.Влажность;
			НоваяСтрока.ВлажностьДляРасчетаУслуг     = СтрокаТаблицы.ВлажностьДляРасчетаУслуг;
			НоваяСтрока.СорнаяПримесь                = СтрокаТаблицы.СорнаяПримесь;
			НоваяСтрока.СорнаяПримесьДляРасчетаУслуг = СтрокаТаблицы.СорнаяПримесьДляРасчетаУслуг;
			НоваяСтрока.ЗерноваяПримесь              = СтрокаТаблицы.ЗерноваяПримесь;
								
		КонецЦикла;
		
	КонецЕсли;
		       		
КонецПроцедуры 

#КонецОбласти

#КонецЕсли