
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
Перем мВерсияОтчета Экспорт;
Перем мПолноеИмяФайлаВнешнейОбработки Экспорт;

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
		
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, НСтр("ru='Утверждена';uk='Затверджена'"),  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   НСтр("ru='Действует с';uk='Діє з'"), 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   НСтр("ru='         по';uk='         по'"), 5);
	
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Мес12УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина Украины от 22.09.2014 г.  № 957';uk='Затверджено наказом Мінфіну України від 22.09.2014 р. № 957'");
	НоваяФорма.ДатаНачалоДействия = '2014-12-01';
	НоваяФорма.ДатаКонецДействия  = '2014-12-31';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина Украины от 22.09.2014 г.  № 957 (в редакции приказа Минфина Украины от 14.11.2014 № 1129) ';uk='Затверджено наказом Мінфіну України від 22.09.2014 р. № 957 (у редакції наказу Мінфіну України від 14.11.2014 № 1129) '");
	НоваяФорма.ДатаНачалоДействия = '2015-01-01';
	НоваяФорма.ДатаКонецДействия  = '2016-03-31';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина Украины от 31.12.2015 г.  № 1307';uk= 'Затверджена наказом Мінфіну України від 31.12.2015 р. № 1307'");
	НоваяФорма.ДатаНачалоДействия = '2016-04-01';
	НоваяФорма.ДатаКонецДействия  = '2017-03-15';
		
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина Украины от 31.12.2015 г.  № 1307 (в редакции Приказа № 276 от 23.02.2017)';uk= 'Затверджена наказом Мінфіну України від 31.12.2015 р. № 1307 (в редакції Наказу № 276 від 23.02.2017)'");
	НоваяФорма.ДатаНачалоДействия = '2017-03-16';
	НоваяФорма.ДатаКонецДействия  = '2018-11-30';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2018УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина Украины от 31.12.2015 г.  № 1307 (в редакции Приказа № 763 от 17.09.2018)';uk= 'Затверджена наказом Мінфіну України від 31.12.2015 р. № 1307 (у редакції Наказу № 763 від 17.09.2018)'");
	НоваяФорма.ДатаНачалоДействия = '2018-12-01';
	НоваяФорма.ДатаКонецДействия  = '2021-02-28';
	
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2021Мес3УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина Украины от 31.12.2015 г.  № 1307 (в редакции Приказа № 131 от 01.03.2021)';uk= 'Затверджена наказом Мінфіну України від 31.12.2015 р. № 1307 (у редакції Наказу № 131 від 01.03.2021)'");
	НоваяФорма.ДатаНачалоДействия = '2021-03-01';
	НоваяФорма.ДатаКонецДействия  = Неопределено;

	ДатаНачалаИспользованияФормыНН13 = РегистрыСведений.НастройкиЗаконодательныхИзменений.ЗначениеНастройки("ДатаНачалаИспользованияФормыНН13");
	Если ЗначениеЗаполнено(ДатаНачалаИспользованияФормыНН13) Тогда
	
		НоваяФорма.ДатаКонецДействия  = ДатаНачалаИспользованияФормыНН13 - 86400;
		
		НоваяФорма = ТаблицаФормОтчета.Добавить();
		НоваяФорма.ФормаОтчета        = "ФормаОтчета2022УФ";
		НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина Украины от 31.12.2015 г.  № 1307 (в редакции Приказа № 15 от 17.01.2022)';uk= 'Затверджена наказом Мінфіну України від 31.12.2015 р. № 1307 (у редакції Наказу № 15 від 17.01.2022)'");
		НоваяФорма.ДатаНачалоДействия = ДатаНачалаИспользованияФормыНН13;
		НоваяФорма.ДатаКонецДействия  = Неопределено;
		
	КонецЕсли;
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

мВерсияОтчета = "БП 2.1.17.1.1";

#КонецЕсли
