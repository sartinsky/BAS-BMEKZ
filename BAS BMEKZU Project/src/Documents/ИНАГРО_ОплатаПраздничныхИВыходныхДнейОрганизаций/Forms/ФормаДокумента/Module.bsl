#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
				
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура("Месяц, Организация, Ответственный", 
		"Объект.ПериодРегистрации",
		"Объект.Организация",
		"Объект.Ответственный");
		
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		УстановитьФункциональныеОпцииФормы();
		
		ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрока");
		
		УправлениеФормой(ЭтаФорма);
		ПодготовитьФормуНаСервере();
		
	КонецЕсли;
	
	// Уведомим о появлении функционала рабочей даты
	НастройкиПредупреждений = ОбщегоНазначенияБП.НастройкиПредупрежденийОбИзменениях("РабочаяДатаИзДокумента");
	
	// Показываем, если это новый документ и сама рабочая дата еще не установлена.
	НастройкиПредупреждений.РабочаяДатаИзДокумента = НастройкиПредупреждений.РабочаяДатаИзДокумента
		И Параметры.Ключ.Пустая()
		И НЕ ЗначениеЗаполнено(БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("РабочаяДата"));
		
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ГрупповоеЗаполнение" И ТипЗнч(Параметр) = Тип("Структура") 
		И Параметр.Свойство("ИдентификаторВызывающейФормы")
		И Параметр.ИдентификаторВызывающейФормы = УникальныйИдентификатор Тогда
		
		ВыполнитьГрупповоеЗаполнение(Параметр);
	КонецЕсли;

	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрока");
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	УстановитьСостояниеДокумента();

КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента);
		
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;

КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()

	УстановитьФункциональныеОпцииФормы();

	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()

	УстановитьФункциональныеОпцииФормы();
	 		
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцНачисленияСтрокойНачалоВыбораЗавершение", ЭтотОбъект);
	ИНАГРО_ЗарплатаКадрыРасширенныйКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрока", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ИНАГРО_ЗарплатаКадрыРасширенныйКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрока", Направление, Модифицированность);

КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ИНАГРО_ЗарплатаКадрыРасширенныйКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ИНАГРО_ЗарплатаКадрыРасширенныйКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНачисления

&НаКлиенте
Процедура НачисленияСотрудникПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Начисления.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.Сотрудник) Тогда
		ДанныеСотрудника = Новый Структура ("Сотрудник, ФизическоеЛицо, 
		|ВидРасчета, ПодразделениеОрганизации, Должность, СпособОтраженияВБухучете, 
		|ПринятНаНовоеРабочееМесто, ГрафикРаботы, ЗанимаемыхСтавок,
		|Размер, Результат, ОтработаноЧасов, ЧасовДвойных");
				
		ЗаполнитьЗначенияСвойств(ДанныеСотрудника, ТекущаяСтрока);
		НачисленияСотрудникПриИзмененииНаСервере(ДанныеСотрудника);
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ДанныеСотрудника);
		
		ТекущаяСтрока.ВидРасчета = ПредопределенноеЗначение("ПланВидовРасчета.ИНАГРО_Начисления.ДоплатаЗаРаботуВПраздники");
		ТекущаяСтрока.ДатаВыхода = Объект.Дата;
		ВыполнитьАвторасчетРеквизитовСтрокиНачисления(ТекущаяСтрока, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НачисленияСотрудникПриИзмененииНаСервере(ДанныеСотрудника)
	
	ИНАГРО_ПроведениеРасчетов.ПолучитьДанныеСотрудника(Объект.Дата, ДанныеСотрудника);
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияСтрокаПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Начисления.ТекущиеДанные;
	РассчитатьРазмер = Не Элемент.Имя = "НачисленияРазмер";
	Если ЗначениеЗаполнено(ТекущаяСтрока.Сотрудник) Тогда
		ВыполнитьАвторасчетРеквизитовСтрокиНачисления(ТекущаяСтрока, РассчитатьРазмер);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
		
	Если Объект.Начисления.Количество() > 0 Тогда
		 
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Продолжить?';uk='Перед заповненням таблична частина буде очищена. Продовжити?'");
		Оповещение = Новый ОписаниеОповещения("ОчиститьТаблицыЗавершение", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		Возврат;
	КонецЕсли;
	
	ИНАГРО_ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуОтбораСпискаРаботников(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ПодобратьСотрудников(Истина);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРаботавшимиВПраздники(Команда)
	
	Если Не ЗаполнитьРаботавшими() Тогда
		ЕстьПраздники = Ложь;
		СписокПраздников = СформироватьСписокПраздников();
		Если СписокПраздников.Количество()>0 Тогда
			ЕстьПраздники = Истина;
		КонецЕсли;	
		Если ЕстьПраздники Тогда
			ТекстСообщения = НСтр("ru='Данные для заполнения документа не обнаружены! Проверьте заполнение производственного календаря на ';uk='Дані для заповнення документу не виявлені! Перевірте заповнення виробничого календаря на '") + Формат(Год(Объект.ПериодРегистрации), "ЧЦ=4; ЧГ=0") + (НСтр("ru=' год!';uk=' рік!'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Иначе
			ТекстСообщения = НСтр("ru='В текущем месяце нет общегосударственных праздников!';uk='В поточному місяці нема загальнодержавних свят!'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	ИначеЕсли Объект.Начисления.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru='Не обнаружено работников, рабочие дни которых пришлись на праздники!';uk='Не виявлено працівників, робочі дні яких прийшлись на свята!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	ТекущаяДатаДокумента = Объект.Дата;
	
	УправлениеФормой(ЭтаФорма);
	
	УстановитьСостояниеДокумента();

КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма); 	
			
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект	 = Форма.Объект;     			
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТаблицыЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт 
   	
    Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
        Возврат;
	КонецЕсли;
	
	Объект.Начисления.Очистить();
	ИНАГРО_ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуОтбораСпискаРаботников(ЭтаФорма, Истина)
		     
КонецПроцедуры

&НаСервере
Функция ПолучитьЧТС(Сотрудник, ДатаАктуальности)
	
	Возврат ИНАГРО_ПроведениеРасчетов.ЧасоваяТарифнаяСтавкаРаботникаОрг(Сотрудник, ДатаАктуальности);
	
КонецФункции

&НаКлиенте
Процедура МесяцНачисленияСтрокойНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	ПриИзмененииМесяцаНачисления();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииМесяцаНачисления()
	ИНАГРО_ЗарплатаКадрыРасширенныйКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрока", Модифицированность);
	
КонецПроцедуры

&НаКлиенте
// Выполняет авторасчет реквизитов шапки
//
Процедура ВыполнитьАвторасчетРеквизитовСтрокиНачисления(ТекущаяСтрока, РассчитатьРазмер)
	
	ДатаАктуальности = ?(ЗначениеЗаполнено(ТекущаяСтрока.ДатаВыхода), ТекущаяСтрока.ДатаВыхода, Объект.Дата);
	// Рассчитаем часовую тарифную ставку работника 
	Если РассчитатьРазмер Тогда
		ЧасовойТариф = ПолучитьЧТС(ТекущаяСтрока.Сотрудник, ДатаАктуальности);
		ТекущаяСтрока.Размер = ЧасовойТариф;
	КонецЕсли;

	// Расчет суммы начисления
	ТекущаяСтрока.Результат = ТекущаяСтрока.Размер * (ТекущаяСтрока.ОтработаноЧасов + ТекущаяСтрока.ЧасовДвойных * 2);
	
КонецПроцедуры // ВыполнитьАвторасчетРеквизитовСтрокиНачисления()

&НаКлиенте
Процедура ВыполнитьГрупповоеЗаполнение(Параметр)
	
	ВыполнитьГрупповоеЗаполнениеНаСервере(Параметр);	
	
	Для Каждого ТекущаяСтрока Из Объект.Начисления Цикл
		ТекущаяСтрока.ВидРасчета = ПредопределенноеЗначение("ПланВидовРасчета.ИНАГРО_Начисления.ДоплатаЗаРаботуВПраздники");
		Если Не ЗначениеЗаполнено(ТекущаяСтрока.ДатаВыхода) Тогда
			ТекущаяСтрока.ДатаВыхода = Объект.Дата;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьГрупповоеЗаполнениеНаСервере(Параметр)
	
	ТаблицаСотрудников = ПолучитьИзВременногоХранилища(Параметр.АдресТЗ);
	ТаблицаСотрудников.Колонки.ДатаНачала.Имя="ДатаВыхода";

	Объект.Начисления.Загрузить(ТаблицаСотрудников);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьСотрудников(МножественныйВыбор)
	
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихВПериоде(
		ЭтаФорма, Объект.Организация, Неопределено,
		Объект.Дата, КонецМесяца(Объект.Дата), МножественныйВыбор,
		АдресСпискаПодобранныхСотрудников());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Сотрудники") Тогда
		ДобавляемыеСотрудники = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыбранноеЗначение);
	Иначе
		ДобавляемыеСотрудники = ВыбранноеЗначение;
	КонецЕсли;

	ДобавитьСотрудников(ДобавляемыеСотрудники);

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСотрудников(Знач СписокСотрудников)
	
	СотрудникиКДобавлению = Новый Массив;
	Для каждого ДобавляемыйСотрудник Из СписокСотрудников Цикл
		
		Если Объект.Начисления.НайтиСтроки(Новый Структура("Сотрудник", ДобавляемыйСотрудник)).Количество() = 0 Тогда
			ТекущаяСтрока = Объект.Начисления.Добавить();
			ТекущаяСтрока.Сотрудник = ДобавляемыйСотрудник;
			ТекущаяСтрока.ДатаВыхода = Объект.Дата; 
			ТекущаяСтрока.ВидРасчета = ПредопределенноеЗначение("ПланВидовРасчета.ИНАГРО_Начисления.ДоплатаЗаРаботуВПраздники");
			Если ЗначениеЗаполнено(ТекущаяСтрока.Сотрудник) Тогда
				
				ДанныеСотрудника = Новый Структура ("Сотрудник, ФизическоеЛицо, 
				|ВидРасчета, ПодразделениеОрганизации, Должность, СпособОтраженияВБухучете, 
				|ПринятНаНовоеРабочееМесто, ГрафикРаботы, ЗанимаемыхСтавок");
				
				ЗаполнитьЗначенияСвойств(ДанныеСотрудника, ТекущаяСтрока);
				НачисленияСотрудникПриИзмененииНаСервере(ДанныеСотрудника);
				ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ДанныеСотрудника);
				
			КонецЕсли;
			
		КонецЕсли; 
		
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Начисления.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
// Функция формирует список государственных праздников в месяце начисления.
//
// Параметры
//
// Возвращаемое значение:
//   СписокПраздников - СписокЗначений   - список государственных праздников.
//
Функция СформироватьСписокПраздников()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ДатаНачала",		НачалоМесяца(Объект.ПериодРегистрации));
	Запрос.УстановитьПараметр("ДатаОкончания",	КонецМесяца(Объект.ПериодРегистрации));
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ 
	|	РегламентированныйПроизводственныйКалендарь.ДатаКалендаря
	|ИЗ
	|	РегистрСведений.ИНАГРО_РегламентированныйПроизводственныйКалендарь КАК РегламентированныйПроизводственныйКалендарь
	|ГДЕ
	|	РегламентированныйПроизводственныйКалендарь.ВидДня = ЗНАЧЕНИЕ(Перечисление.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Праздник)
	|	И РегламентированныйПроизводственныйКалендарь.ДатаКалендаря МЕЖДУ &ДатаНачала И &ДатаОкончания";
	
	СписокПраздников = Новый СписокЗначений;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокПраздников.Добавить(Выборка.ДатаКалендаря, Формат(Выборка.ДатаКалендаря, "ДФ='d ММММ'"));
	КонецЦикла;
	
	Возврат СписокПраздников
	
КонецФункции // СформироватьСписокПраздников()

&НаСервере
Функция ЗаполнитьРаботавшими() 
	
	Запрос = Новый Запрос;
	
	Праздники = Новый СписокЗначений;
	Праздники.Добавить(Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Праздник);
	Праздники.Добавить(Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Воскресенье);
	Запрос.УстановитьПараметр("Праздники",			Праздники);
	
	РасчетыПоЧасам = Новый Массив(2);
	РасчетыПоЧасам[0] = ПланыВидовРасчета.ИНАГРО_Начисления.ТарифЧасовой;
	РасчетыПоЧасам[1] = ПланыВидовРасчета.ИНАГРО_Начисления.СдельныйНаряд;
	Запрос.УстановитьПараметр("РасчетыПоЧасам",		РасчетыПоЧасам);
	
	МесячныеСтавки = Новый Массив(2);
	МесячныеСтавки[0] = ПланыВидовРасчета.ИНАГРО_Начисления.ОкладПоДням;
	МесячныеСтавки[1] = ПланыВидовРасчета.ИНАГРО_Начисления.ОкладПоЧасам;
	Запрос.УстановитьПараметр("МесячныеСтавки",		МесячныеСтавки);
	
	Запрос.УстановитьПараметр("НачальнаяДата",		'00010101');
	Запрос.УстановитьПараметр("Год",				Год(Объект.ПериодРегистрации));
	Запрос.УстановитьПараметр("ДатаНачала",			НачалоМесяца(Объект.ПериодРегистрации));
	Запрос.УстановитьПараметр("ДатаОкончания",		КонецМесяца(Объект.ПериодРегистрации));
	Запрос.УстановитьПараметр("ПериодРегистрации",	Объект.ПериодРегистрации);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация",Объект.Организация);
	Запрос.УстановитьПараметр("Подразделение", 		Объект.ПодразделениеОрганизации);
	
	ПраздничныеДатыТекст =
	"ВЫБРАТЬ 
	|	РегламентированныйПроизводственныйКалендарь.ДатаКалендаря КАК ДатаКалендаря
	|ИЗ
	|	РегистрСведений.ИНАГРО_РегламентированныйПроизводственныйКалендарь КАК РегламентированныйПроизводственныйКалендарь
	|ГДЕ
	|	РегламентированныйПроизводственныйКалендарь.ВидДня В(&Праздники)
	|	И РегламентированныйПроизводственныйКалендарь.ДатаКалендаря МЕЖДУ &ДатаНачала И &ДатаОкончания";
	
	Запрос.Текст = ПраздничныеДатыТекст;
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда // в этом месяце праздничных дней не оказалось
		Возврат Ложь
	КонецЕсли;
	
	ПраздникиТекущегоМесяца = Результат.Выгрузить().ВыгрузитьКолонку("ДатаКалендаря");
	Запрос.УстановитьПараметр("ПраздникиТекущегоМесяца", ПраздникиТекущегоМесяца);
	Запрос.УстановитьПараметр("ПервыйПраздник", ПраздникиТекущегоМесяца[0]);
	// СотрудникиПоПраздникам
	//		Таблица работающих по состоянию на каждый праздничный день с их кадровыми данными.
	// 
	//	Поля:
	//		ПраздничныйДень - дата, общегосударственный праздник
	//		Сотрудник,
	//		ПодразделениеОрганизации,
	//		ГрафикРаботы,
	//		ВидГрафика,
	//		ДлительностьРабочейНедели
	// 
	// Описание:
	// 
	//	"псевдосрез" последних из РегистрСведений.РаботникиОрганизаций 
	//	для списка праздников текущего месяца.
	
	СотрудникиПоПраздникамТекст =
	"ВЫБРАТЬ 
	|	Даты.ПраздничныйДень КАК ПраздничныйДень,
	|	Даты.Сотрудник КАК Сотрудник,
	|	РаботникиОрганизаций.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	|	РаботникиОрганизаций.ГрафикРаботы КАК ГрафикРаботы,
	|	РаботникиОрганизаций.ГрафикРаботы.ВидГрафика КАК ВидГрафика,
	|	ЕСТЬNULL(РаботникиОрганизаций.ГрафикРаботы.ДлительностьРабочейНедели, 0) КАК ДлительностьРабочейНедели
	|ИЗ
	|	(ВЫБРАТЬ
	|		ПраздничныеДаты.ДатаКалендаря КАК ПраздничныйДень,
	|		РаботникиОрганизаций.Сотрудник КАК Сотрудник,
	|		МАКСИМУМ(РаботникиОрганизаций.Период) КАК Период
	|	ИЗ
	|		("+ ПраздничныеДатыТекст + ") КАК ПраздничныеДаты
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_РаботникиОрганизаций КАК РаботникиОрганизаций
	|			ПО ПраздничныеДаты.ДатаКалендаря >= РаботникиОрганизаций.Период
	|	ГДЕ
	|		РаботникиОрганизаций.Организация = &ГоловнаяОрганизация
	|	
	|	СГРУППИРОВАТЬ ПО
	|		РаботникиОрганизаций.Сотрудник,
	|		ПраздничныеДаты.ДатаКалендаря) КАК Даты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_РаботникиОрганизаций КАК РаботникиОрганизаций
	|		ПО Даты.Период = РаботникиОрганизаций.Период
	|			И Даты.Сотрудник = РаботникиОрганизаций.Сотрудник
	|ГДЕ
	|	РаботникиОрганизаций.Организация = &ГоловнаяОрганизация "+
	?(ЗначениеЗаполнено(Объект.ПодразделениеОрганизации), " И РаботникиОрганизаций.ПодразделениеОрганизации = &Подразделение ","")
	+"	И 
	|	РаботникиОрганизаций.ПричинаИзмененияСостояния  <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)";
	
	Запрос.Текст = СотрудникиПоПраздникамТекст;
	
	
	СотрудникиПоПраздникамМаксимумТекст =
	"ВЫБРАТЬ 
	|	МАКСИМУМ(Даты.ПраздничныйДень) КАК ПраздничныйДень,
	|	Даты.Сотрудник КАК Сотрудник,
	|	РаботникиОрганизаций.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	|	РаботникиОрганизаций.ГрафикРаботы КАК ГрафикРаботы,
	|	РаботникиОрганизаций.ГрафикРаботы.ВидГрафика КАК ВидГрафика,
	|	ЕСТЬNULL(РаботникиОрганизаций.ГрафикРаботы.ДлительностьРабочейНедели, 0) КАК ДлительностьРабочейНедели
	|ИЗ
	|	(ВЫБРАТЬ
	|		ПраздничныеДаты.ДатаКалендаря КАК ПраздничныйДень,
	|		РаботникиОрганизаций.Сотрудник КАК Сотрудник,
	|		МАКСИМУМ(РаботникиОрганизаций.Период) КАК Период
	|	ИЗ
	|		(ВЫБРАТЬ
	|			РегламентированныйПроизводственныйКалендарь.ДатаКалендаря КАК ДатаКалендаря
	|		ИЗ
	|			РегистрСведений.ИНАГРО_РегламентированныйПроизводственныйКалендарь КАК РегламентированныйПроизводственныйКалендарь
	|		ГДЕ
	|			РегламентированныйПроизводственныйКалендарь.ВидДня В(&Праздники)
	|			И РегламентированныйПроизводственныйКалендарь.ДатаКалендаря МЕЖДУ &ДатаНачала И &ДатаОкончания) КАК ПраздничныеДаты
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_РаботникиОрганизаций КАК РаботникиОрганизаций
	|			ПО ПраздничныеДаты.ДатаКалендаря >= РаботникиОрганизаций.Период
	|	ГДЕ
	|		РаботникиОрганизаций.Организация = &ГоловнаяОрганизация
	|	
	|	СГРУППИРОВАТЬ ПО
	|		РаботникиОрганизаций.Сотрудник,
	|		ПраздничныеДаты.ДатаКалендаря) КАК Даты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_РаботникиОрганизаций КАК РаботникиОрганизаций
	|		ПО Даты.Период = РаботникиОрганизаций.Период
	|			И Даты.Сотрудник = РаботникиОрганизаций.Сотрудник
	|ГДЕ
	|	РаботникиОрганизаций.Организация = &ГоловнаяОрганизация"+
	?(ЗначениеЗаполнено(Объект.ПодразделениеОрганизации), " И РаботникиОрганизаций.ПодразделениеОрганизации = &Подразделение ","")
	+"	И РаботникиОрганизаций.ПричинаИзмененияСостояния <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|
	|СГРУППИРОВАТЬ ПО
	|	Даты.Сотрудник,
	|	РаботникиОрганизаций.ПодразделениеОрганизации,
	|	РаботникиОрганизаций.ГрафикРаботы,
	|	РаботникиОрганизаций.ГрафикРаботы.ВидГрафика,
	|	ЕСТЬNULL(РаботникиОрганизаций.ГрафикРаботы.ДлительностьРабочейНедели, 0)";
	Запрос.Текст = СотрудникиПоПраздникамМаксимумТекст;
	
	СостояниеСотрудниковПоПраздникамТекст =
	"ВЫБРАТЬ 
	|	Даты.ПраздничныйДень КАК ПраздничныйДень,
	|	Даты.Сотрудник КАК Сотрудник,
	|	СостояниеРаботниковОрганизаций.Состояние КАК Состояние
	|ИЗ
	|	(ВЫБРАТЬ
	|		ПраздничныеДаты.ДатаКалендаря КАК ПраздничныйДень,
	|		СостояниеРаботниковОрганизаций.Сотрудник КАК Сотрудник,
	|		МАКСИМУМ(СостояниеРаботниковОрганизаций.Период) КАК Период
	|	ИЗ
	|		("+ ПраздничныеДатыТекст + ") КАК ПраздничныеДаты
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_СостояниеРаботниковОрганизаций КАК СостояниеРаботниковОрганизаций
	|			ПО ПраздничныеДаты.ДатаКалендаря >= СостояниеРаботниковОрганизаций.Период
	|	ГДЕ
	|		СостояниеРаботниковОрганизаций.Организация = &ГоловнаяОрганизация
	|	
	|	СГРУППИРОВАТЬ ПО
	|		СостояниеРаботниковОрганизаций.Сотрудник,
	|		ПраздничныеДаты.ДатаКалендаря) КАК Даты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_СостояниеРаботниковОрганизаций КАК СостояниеРаботниковОрганизаций
	|		ПО Даты.Период = СостояниеРаботниковОрганизаций.Период
	|			И Даты.Сотрудник = СостояниеРаботниковОрганизаций.Сотрудник
	|ГДЕ
	|	СостояниеРаботниковОрганизаций.Организация = &ГоловнаяОрганизация";
	Запрос.Текст = СостояниеСотрудниковПоПраздникамТекст;
	
	ОбщиеГрафикиРаботыТекст =
	"ВЫБРАТЬ 
	|	ГрафикиРаботыПоВидамВремени.ГрафикРаботы КАК ГрафикРаботы,
	|	ГрафикиРаботыПоВидамВремени.Дата КАК РабочийДень,
	|	ГрафикиРаботыПоВидамВремени.ДополнительноеЗначение КАК Часы,
	|	ГрафикиРаботыПоВидамВремени.ПроизводственныйКалендарьКалендарныеДни КАК КалендарныеДни
	|ИЗ
	|	РегистрСведений.ИНАГРО_ГрафикиРаботыПоВидамВремени КАК ГрафикиРаботыПоВидамВремени
	|ГДЕ
	|	ГрафикиРаботыПоВидамВремени.ОсновноеЗначение <> 0
	|	И ГрафикиРаботыПоВидамВремени.ВидУчетаВремени = ЗНАЧЕНИЕ(Перечисление.ИНАГРО_ВидыУчетаВремени.ПоДням)
	|	И НАЧАЛОПЕРИОДА(ГрафикиРаботыПоВидамВремени.Дата, МЕСЯЦ) = &ПериодРегистрации
	|	И ГрафикиРаботыПоВидамВремени.Дата В(&ПраздникиТекущегоМесяца)
	|	И ГрафикиРаботыПоВидамВремени.ГрафикРаботы ССЫЛКА Справочник.ИНАГРО_ГрафикиРаботы";
	Запрос.Текст = ОбщиеГрафикиРаботыТекст;
	
	ОбщиеГрафикиРаботыТекстСумма =
	"ВЫБРАТЬ 
	|	ГрафикиРаботыПоВидамВремени.ГрафикРаботы КАК ГрафикРаботы,
	|	МАКСИМУМ(ГрафикиРаботыПоВидамВремени.Дата) КАК РабочийДень,
	|	СУММА(ГрафикиРаботыПоВидамВремени.ДополнительноеЗначение) КАК Часы,
	|	СУММА(ГрафикиРаботыПоВидамВремени.ПроизводственныйКалендарьКалендарныеДни) КАК КалендарныеДни
	|ИЗ
	|	РегистрСведений.ИНАГРО_ГрафикиРаботыПоВидамВремени КАК ГрафикиРаботыПоВидамВремени
	|ГДЕ
	|	ГрафикиРаботыПоВидамВремени.ОсновноеЗначение <> 0
	|	И ГрафикиРаботыПоВидамВремени.ВидУчетаВремени = ЗНАЧЕНИЕ(Перечисление.ИНАГРО_ВидыУчетаВремени.ПоДням)
	|	И НАЧАЛОПЕРИОДА(ГрафикиРаботыПоВидамВремени.Дата, МЕСЯЦ) = &ПериодРегистрации
	|	И ГрафикиРаботыПоВидамВремени.ГрафикРаботы ССЫЛКА Справочник.ИНАГРО_ГрафикиРаботы
	|
	|СГРУППИРОВАТЬ ПО
	|	ГрафикиРаботыПоВидамВремени.ГрафикРаботы";
	Запрос.Текст = ОбщиеГрафикиРаботыТекстСумма;
	
	ФактическиОтработаноТекст =
	"ВЫБРАТЬ 
	|	ГрафикиРаботыПоВидамВремени.Сотрудник КАК Сотрудник,
	|	ГрафикиРаботыПоВидамВремени.Период КАК РабочийДень,
	|	ГрафикиРаботыПоВидамВремени.Часов КАК Часы,
	|	ГрафикиРаботыПоВидамВремени.ВЦеломЗаПериод
	|ИЗ
	|	РегистрНакопления.ИНАГРО_РабочееВремяРаботниковОрганизаций КАК ГрафикиРаботыПоВидамВремени
	|ГДЕ
	|	ГрафикиРаботыПоВидамВремени.Организация = &ГоловнаяОрганизация
	|	И НАЧАЛОПЕРИОДА(ГрафикиРаботыПоВидамВремени.Период, МЕСЯЦ) = &ПериодРегистрации
	|	И (НЕ ГрафикиРаботыПоВидамВремени.ВЦеломЗаПериод)
	|	И (ГрафикиРаботыПоВидамВремени.ВидИспользованияРабочегоВремени = ЗНАЧЕНИЕ(Справочник.ИНАГРО_КлассификаторИспользованияРабочегоВремени.Работа)
	|	ИЛИ ГрафикиРаботыПоВидамВремени.ВидИспользованияРабочегоВремени = ЗНАЧЕНИЕ(Справочник.ИНАГРО_КлассификаторИспользованияРабочегоВремени.РаботаВыходныеИПраздничные))
	|	И ГрафикиРаботыПоВидамВремени.Период В(&ПраздникиТекущегоМесяца)";
	Запрос.Текст = ФактическиОтработаноТекст;
	
	ФактическиОтработаноТекстВЦелом =
	"ВЫБРАТЬ 
	|	ГрафикиРаботыПоВидамВремени.Сотрудник,
	|	&ПервыйПраздник КАК РабочийДень,
	|	ГрафикиРаботыПоВидамВремени.Часов КАК Часы,
	|	ГрафикиРаботыПоВидамВремени.ВЦеломЗаПериод
	|ИЗ
	|	РегистрНакопления.ИНАГРО_РабочееВремяРаботниковОрганизаций КАК ГрафикиРаботыПоВидамВремени
	|ГДЕ
	|	ГрафикиРаботыПоВидамВремени.Организация = &ГоловнаяОрганизация
	|	И НАЧАЛОПЕРИОДА(ГрафикиРаботыПоВидамВремени.Период, МЕСЯЦ) = &ПериодРегистрации
	|	И ГрафикиРаботыПоВидамВремени.ВЦеломЗаПериод
	|	И ГрафикиРаботыПоВидамВремени.ВидИспользованияРабочегоВремени = ЗНАЧЕНИЕ(Справочник.ИНАГРО_КлассификаторИспользованияРабочегоВремени.РаботаВыходныеИПраздничные)";
	Запрос.Текст = ФактическиОтработаноТекстВЦелом;
	
	СводныеТабелиРаботыТекст =
	"ВЫБРАТЬ  РАЗЛИЧНЫЕ
	|	РабочееВремяРаботниковОрганизаций.Сотрудник КАК Сотрудник
	|ИЗ
	|	РегистрНакопления.ИНАГРО_РабочееВремяРаботниковОрганизаций КАК РабочееВремяРаботниковОрганизаций
	|ГДЕ
	|	РабочееВремяРаботниковОрганизаций.Организация = &ГоловнаяОрганизация
	|	И НАЧАЛОПЕРИОДА(РабочееВремяРаботниковОрганизаций.Период, ДЕНЬ) = &ПериодРегистрации
	|	И РабочееВремяРаботниковОрганизаций.ВЦеломЗаПериод
	|	И РабочееВремяРаботниковОрганизаций.ВидИспользованияРабочегоВремени.РабочееВремя";
	Запрос.Текст = СводныеТабелиРаботыТекст;
	
	ПлановыеНачисленияРаботниковОрганизацийТекст =
	"ВЫБРАТЬ 
	|	Даты.ПраздничныйДень КАК ПраздничныйДень,
	|	Даты.Сотрудник КАК Сотрудник,
	|	ПлановыеНачисленияРаботниковОрганизаций.ВидРасчета КАК СпособРасчета,
	|	ПлановыеНачисленияРаботниковОрганизаций.Показатель1    КАК Размер
	|ИЗ
	|	(ВЫБРАТЬ
	|		ПраздничныеДаты.ДатаКалендаря КАК ПраздничныйДень,
	|		ПлановыеНачисленияРаботниковОрганизаций.Сотрудник КАК Сотрудник,
	|		МАКСИМУМ(ПлановыеНачисленияРаботниковОрганизаций.Период) КАК Период
	|	ИЗ
	|		("+ ПраздничныеДатыТекст + ") КАК ПраздничныеДаты
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_ПлановыеНачисленияРаботниковОрганизаций КАК ПлановыеНачисленияРаботниковОрганизаций
	|			ПО ПраздничныеДаты.ДатаКалендаря >= ПлановыеНачисленияРаботниковОрганизаций.Период
	|	ГДЕ
	|		ПлановыеНачисленияРаботниковОрганизаций.Организация = &ГоловнаяОрганизация
	|		И ПлановыеНачисленияРаботниковОрганизаций.ВидНачисления = ЗНАЧЕНИЕ(Перечисление.ИНАГРО_ВидыНачисленийРаботникаОрганизации.Основное)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ПлановыеНачисленияРаботниковОрганизаций.Сотрудник,
	|		ПраздничныеДаты.ДатаКалендаря) КАК Даты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_ПлановыеНачисленияРаботниковОрганизаций КАК ПлановыеНачисленияРаботниковОрганизаций
	|		ПО Даты.Период = ПлановыеНачисленияРаботниковОрганизаций.Период
	|			И Даты.Сотрудник = ПлановыеНачисленияРаботниковОрганизаций.Сотрудник
	|ГДЕ
	|	ПлановыеНачисленияРаботниковОрганизаций.Организация = &ГоловнаяОрганизация
	|	И ПлановыеНачисленияРаботниковОрганизаций.ВидНачисления = ЗНАЧЕНИЕ(Перечисление.ИНАГРО_ВидыНачисленийРаботникаОрганизации.Основное)";
	Запрос.Текст = ПлановыеНачисленияРаботниковОрганизацийТекст;
	// ДанныеПроизводственногоКалендаря
	//		Данные производственного календаря для расчета среднемесячного количества часов.
	// 
	//	Поля:
	//		ЧислоРабочихДней,
	//		ЧислоПредпраздничныхДней
	// 
	// Описание:
	//
	//	данные по рабочим и предпраздничным дням выбираются из РегистрСведений.РегламентированныйПроизводственныйКалендарь.	
	
	ДанныеПроизводственногоКалендаряТекст =
	"ВЫБРАТЬ 
	|	СУММА(ВЫБОР
	|			КОГДА РегламентированныйПроизводственныйКалендарь.ВидДня = ЗНАЧЕНИЕ(Перечисление.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Рабочий)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ЧислоРабочихДней,
	|	СУММА(ВЫБОР
	|			КОГДА РегламентированныйПроизводственныйКалендарь.ВидДня = ЗНАЧЕНИЕ(Перечисление.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Предпраздничный)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ЧислоПредпраздничныхДней
	|ИЗ
	|	РегистрСведений.ИНАГРО_РегламентированныйПроизводственныйКалендарь КАК РегламентированныйПроизводственныйКалендарь
	|ГДЕ
	|	РегламентированныйПроизводственныйКалендарь.Год = &Год";
	Запрос.Текст = ДанныеПроизводственногоКалендаряТекст;
	
	ТекстПоляОтработаноЧасов = 
	"	ВЫБОР
	|		КОГДА ФактическиОтработано.Сотрудник ЕСТЬ НЕ NULL 
	|			ТОГДА ФактическиОтработано.Часы
	|
	|		ИНАЧЕ ОбщиеГрафикиРаботы.Часы
	|	КОНЕЦ";
	
	ТекстПоляРазмер = 
	"	ВЫБОР
	|		КОГДА ПлановыеНачисленияРаботниковОрганизаций.СпособРасчета В (&РасчетыПоЧасам)
	|			ТОГДА ПлановыеНачисленияРаботниковОрганизаций.Размер
	|		КОГДА ПлановыеНачисленияРаботниковОрганизаций.СпособРасчета В (&МесячныеСтавки)
	|			ТОГДА ВЫБОР
	|					 КОГДА ЕСТЬNULL(ДанныеПроизводственногоКалендаря.ЧислоРабочихДней, 0) = 0
	|						ТОГДА 0
	|					 КОГДА СотрудникиПоПраздникам.ДлительностьРабочейНедели = 0
	|						ТОГДА 0
	|					 ИНАЧЕ ПлановыеНачисленияРаботниковОрганизаций.Размер / ОбщиеГрафикиРаботыСумма.Часы
	|				   КОНЕЦ
	|		КОГДА ПлановыеНачисленияРаботниковОрганизаций.СпособРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ИНАГРО_Начисления.ТарифДневной)
	|			ТОГДА ВЫБОР
	|					КОГДА СотрудникиПоПраздникам.ДлительностьРабочейНедели = 0
	|						ТОГДА 0
	|					ИНАЧЕ ПлановыеНачисленияРаботниковОрганизаций.Размер  / СотрудникиПоПраздникам.ДлительностьРабочейНедели * 
	|							5
	|				КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ";
	
	//  Основной текст запроса
	// 
	//	Поля:
	//		соответствуют реквизитам т.ч. документа.
	//	
	// Описание:
	//
	// из всех сотрудников организации отбираются только те, по которым в ИБ присутствуют
	// следующие данные:
	//  или документом Табель введено фактически отработанное время в дни праздников
	//  или введен индивидуальный график, в котором праздничный день помечен как рабочий
	//  или в назначенном работнику по состоянию на дату праздника графике праздничный день помечен как рабочий.
	//
	// из выборки исключаются работники, по которым не введено фактически отработанное время
	// в дни праздников, но:
	//  введен сводный индивидуальный график или сводный табель
	//  по данным кадрового учета они отсутствуют на рабочем месте, т.е. болеют, находятся в отпуске и т.п.
	//
	// отработано часов выбирается в следующем порядке:
	//	фактически отработанное время (выборка ФактическиОтработано), 
	//	затем данные индивидуального графика работы (выборка ИндивидуальныеГрафикиРаботы),
	//	затем данные текущего графика работы сотрудника (выборка ОбщиеГрафикиРаботы)
	// размер (часовая тарифная ставка) определяется в зависимости от порядка расчета основного начисления сотрудника
	//	с использованием среднемесячного количества часов и длительности рабочей недели графика 
	// в качестве вида расчета вводим доплату за праздничный день.
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ 
	|	СотрудникиПоПраздникам.Сотрудник,
	|	СотрудникиПоПраздникам.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
	|	СотрудникиПоПраздникам.ПодразделениеОрганизации,
	|	СотрудникиПоПраздникам.ПраздничныйДень КАК ДатаВыхода,
	|   СводныеТабелиРаботы.Сотрудник КАК СотрудникСводный,
	|   ФактическиОтработано.ВЦеломЗаПериод,
	|   ОбщиеГрафикиРаботы.Часы,
	|   ОбщиеГрафикиРаботы.КалендарныеДни,
	|   ФактическиОтработано.Сотрудник КАК СотрудникФактически,
	|	" + ТекстПоляОтработаноЧасов + " КАК ОтработаноЧасов,
	|	0 КАК ЧасовДвойных,
	|	" + ТекстПоляРазмер + " КАК Размер,
	|	" + ТекстПоляОтработаноЧасов +"  * " + ТекстПоляРазмер + " КАК Результат,
	|	ЗНАЧЕНИЕ(ПланВидовРасчета.ИНАГРО_Начисления.ДоплатаЗаРаботуВПраздники) КАК ВидРасчета
	|ИЗ
	|	(" + СотрудникиПоПраздникамТекст + ") КАК СотрудникиПоПраздникам
	|		ЛЕВОЕ СОЕДИНЕНИЕ (" + ФактическиОтработаноТекст + ") КАК ФактическиОтработано
	|		ПО СотрудникиПоПраздникам.ПраздничныйДень = ФактическиОтработано.РабочийДень
	|			И СотрудникиПоПраздникам.Сотрудник = ФактическиОтработано.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ (" + СостояниеСотрудниковПоПраздникамТекст + ") КАК СостояниеСотрудниковПоПраздникам
	|		ПО СотрудникиПоПраздникам.ПраздничныйДень = СостояниеСотрудниковПоПраздникам.ПраздничныйДень
	|			И СотрудникиПоПраздникам.Сотрудник = СостояниеСотрудниковПоПраздникам.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ (" + ОбщиеГрафикиРаботыТекст + ") КАК ОбщиеГрафикиРаботы
	|		ПО СотрудникиПоПраздникам.ПраздничныйДень = ОбщиеГрафикиРаботы.РабочийДень
	|			И СотрудникиПоПраздникам.ГрафикРаботы = ОбщиеГрафикиРаботы.ГрафикРаботы
	|		ЛЕВОЕ СОЕДИНЕНИЕ (" + ОбщиеГрафикиРаботыТекстСумма + ") КАК ОбщиеГрафикиРаботыСумма
	|			ПО СотрудникиПоПраздникам.ГрафикРаботы = ОбщиеГрафикиРаботыСумма.ГрафикРаботы
	|		ЛЕВОЕ СОЕДИНЕНИЕ (" + СводныеТабелиРаботыТекст + ") КАК СводныеТабелиРаботы
	|		ПО СотрудникиПоПраздникам.Сотрудник = СводныеТабелиРаботы.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ (" + ПлановыеНачисленияРаботниковОрганизацийТекст + ") КАК ПлановыеНачисленияРаботниковОрганизаций
	|		ПО СотрудникиПоПраздникам.ПраздничныйДень = ПлановыеНачисленияРаботниковОрганизаций.ПраздничныйДень
	|			И СотрудникиПоПраздникам.Сотрудник = ПлановыеНачисленияРаботниковОрганизаций.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ (" + ДанныеПроизводственногоКалендаряТекст + ") КАК ДанныеПроизводственногоКалендаря
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ВЫБОР
	|			КОГДА ФактическиОтработано.Сотрудник ЕСТЬ НЕ NULL  
	|				ТОГДА ФактическиОтработано.Сотрудник
	|			ИНАЧЕ ОбщиеГрафикиРаботы.ГрафикРаботы
	|		КОНЕЦ ЕСТЬ НЕ NULL 
	|	И (НЕ ВЫБОР
	|				КОГДА СводныеТабелиРаботы.Сотрудник ЕСТЬ НЕ NULL 
	|			И (НЕ ФактическиОтработано.ВЦеломЗаПериод)
	|					ТОГДА ИСТИНА
	|          КОГДА ОбщиеГрафикиРаботы.Часы <> 0
	|			И ОбщиеГрафикиРаботы.КалендарныеДни = 1
	|			ТОГДА Истина	
	|				КОГДА ФактическиОтработано.Сотрудник ЕСТЬ НЕ NULL
	|					ТОГДА ЛОЖЬ
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ)  // ЭтоСотрудникСоСводнымГрафиком 
	|	И ВЫБОР
	|			КОГДА ФактическиОтработано.Сотрудник ЕСТЬ НЕ NULL  
	|				ТОГДА ЗНАЧЕНИЕ(Перечисление.ИНАГРО_СостоянияРаботникаОрганизации.Работает)
	|			ИНАЧЕ ЕСТЬNULL(СостояниеСотрудниковПоПраздникам.Состояние, ЗНАЧЕНИЕ(Перечисление.ИНАГРО_СостоянияРаботникаОрганизации.Работает))
	|		КОНЕЦ = ЗНАЧЕНИЕ(Перечисление.ИНАГРО_СостоянияРаботникаОрганизации.Работает)";
		
	Объект.Начисления.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Возврат Истина
	
КонецФункции // ЗаполнитьРаботавшимиВПраздники()

#КонецОбласти 

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
