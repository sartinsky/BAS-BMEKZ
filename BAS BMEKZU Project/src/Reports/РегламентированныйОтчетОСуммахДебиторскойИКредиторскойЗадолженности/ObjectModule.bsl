
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
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2013УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Госкомстата Украины от 07.07.2012 р. № 286';uk='Затверджена наказом Держкомстату України від 07.07.2012 р. № 286'"); 
	НоваяФорма.ДатаНачалоДействия = '20130101';
	НоваяФорма.ДатаКонецДействия  = '20210131';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2021УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Госстата Украины от 25.06.2021 г. № 131';uk='Затверджена наказом Держстату України від 25.06.2021 р. № 131'"); 
	НоваяФорма.ДатаНачалоДействия = '20130101';
	НоваяФорма.ДатаКонецДействия  = '20211231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2022УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Госстата Украины от 10.06.2022г. № 178';uk='Затверджена наказом Держстату України від 10.06.2022р. № 178'"); 
	НоваяФорма.ДатаНачалоДействия = '20220101';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

мВерсияОтчета = "БП 2.1.21.3.1";

#КонецЕсли

