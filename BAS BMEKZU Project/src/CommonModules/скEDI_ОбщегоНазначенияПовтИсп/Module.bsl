// Возвращает Истина, если конфигурация запущена под управлением платформы 1С:Предприятие 8.3 без использования режима совместимости
// с версией 8.3.2 или более ранней.
//
Функция ЭтоПлатформа83БезРежимаСовместимости() Экспорт
	
	Информация = Новый СистемнаяИнформация;
	Возврат Лев(Информация.ВерсияПриложения, 3) = "8.3"
		И (Метаданные.РежимСовместимости = Метаданные.СвойстваОбъектов.РежимСовместимости.НеИспользовать
		Или (Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости.Версия8_1
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости.Версия8_2_13
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости["Версия8_2_16"]
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости["Версия8_3_1"]
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости["Версия8_3_2"]));
	
КонецФункции
	
Функция ЭтоПлатформа82() Экспорт
	
	Информация = Новый СистемнаяИнформация;
	Возврат Лев(Информация.ВерсияПриложения, 3) = "8.2";		
	
КонецФункции

Функция ЭтоРежимБезМодальности() Экспорт
	Возврат Метаданные.РежимИспользованияМодальности = Метаданные.СвойстваОбъектов.РежимИспользованияМодальности.НеИспользовать;	
КонецФункции
