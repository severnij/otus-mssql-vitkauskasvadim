/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, JOIN".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД WideWorldImporters можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Все товары, в названии которых есть "urgent" или название начинается с "Animal".
Вывести: ИД товара (StockItemID), наименование товара (StockItemName).
Таблицы: Warehouse.StockItems.
*/

SELECT
	StockItemID,
	StockItemName

FROM
	Warehouse.StockItems

WHERE
	StockItemName LIKE '%urgent%'
	OR StockItemName LIKE 'Animal%';

/*
2. Поставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders).
Сделать через JOIN, с подзапросом задание принято не будет.
Вывести: ИД поставщика (SupplierID), наименование поставщика (SupplierName).
Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders.
По каким колонкам делать JOIN подумайте самостоятельно.
*/

SELECT
	sups.SupplierID,
	sups.SupplierName

FROM Purchasing.Suppliers AS sups
	LEFT JOIN Purchasing.PurchaseOrders AS ords
		ON sups.SupplierID = ords.SupplierID
WHERE
	ords.SupplierID IS NULL;

/*
3. Заказы (Orders) с ценой товара (UnitPrice) более 100$ 
либо количеством единиц (Quantity) товара более 20 штук
и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
Вывести:
* OrderID
* дату заказа (OrderDate) в формате ДД.ММ.ГГГГ
* название месяца, в котором был сделан заказ
* номер квартала, в котором был сделан заказ
* треть года, к которой относится дата заказа (каждая треть по 4 месяца)
* имя заказчика (Customer)
Добавьте вариант этого запроса с постраничной выборкой,
пропустив первую 1000 и отобразив следующие 100 записей.

Сортировка должна быть по номеру квартала, трети года, дате заказа (везде по возрастанию).

Таблицы: Sales.Orders, Sales.OrderLines, Sales.Customers.
*/

SELECT
	
	o.OrderID,
	CONVERT(varchar, o.OrderDate, 104) AS OrderDate,
	DATENAME(MONTH, o.OrderDate) AS OrderMonth,
	DATEPART(QUARTER, o.OrderDate) AS OrderQuarter,
	CASE 
		WHEN MONTH(o.OrderDate) BETWEEN 1 AND 4 THEN N'Первая Треть Года'
		WHEN MONTH(o.OrderDate) BETWEEN 5 AND 8 THEN N'Вторая Треть Года'
		WHEN MONTH(o.OrderDate) BETWEEN 9 AND 12 THEN N'Третья Треть Года'
	END AS 'Треть Года',
	c.CustomerName

FROM Sales.Orders AS o
	LEFT JOIN Sales.OrderLines AS ol ON o.OrderID = ol.OrderID
	LEFT JOIN Sales.Customers AS c ON o.CustomerID = c.CustomerID

WHERE
	(ol.UnitPrice > 100 OR ol.Quantity > 20) AND ol.PickingCompletedWhen IS NOT NULL;


DECLARE
	@pagesize	BIGINT = 100, -- Размер страницы.
	@pagenumber	BIGINT = 10; -- Номер страницы.

SELECT
	
	o.OrderID,
	CONVERT(varchar, o.OrderDate, 104) AS OrderDate,
	DATENAME(MONTH, o.OrderDate) AS OrderMonth,
	DATEPART(QUARTER, o.OrderDate) AS OrderQuarter,
	CASE 
		WHEN MONTH(o.OrderDate) BETWEEN 1 AND 4 THEN N'Треть Года 1'
		WHEN MONTH(o.OrderDate) BETWEEN 5 AND 8 THEN N'Треть Года 2'
		WHEN MONTH(o.OrderDate) BETWEEN 9 AND 12 THEN N'Треть Года 3'
	END AS [Треть Года],
	c.CustomerName

FROM Sales.Orders AS o
	LEFT JOIN Sales.OrderLines AS ol ON o.OrderID = ol.OrderID
	LEFT JOIN Sales.Customers AS c ON o.CustomerID = c.CustomerID

WHERE
	(ol.UnitPrice > 100 OR ol.Quantity > 20) AND ol.PickingCompletedWhen IS NOT NULL
	
ORDER BY
	OrderQuarter, [Треть Года], OrderDate

OFFSET @pagesize * @pagenumber ROWS FETCH NEXT @pagesize ROWS ONLY;

/*
4. Заказы поставщикам (Purchasing.Suppliers),
которые должны быть исполнены (ExpectedDeliveryDate) в январе 2013 года
с доставкой "Air Freight" или "Refrigerated Air Freight" (DeliveryMethodName)
и которые исполнены (IsOrderFinalized).
Вывести:
* способ доставки (DeliveryMethodName)
* дата доставки (ExpectedDeliveryDate)
* имя поставщика
* имя контактного лица принимавшего заказ (ContactPerson)

Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.
*/

напишите здесь свое решение

/*
5. Десять последних продаж (по дате продажи) с именем клиента и именем сотрудника,
который оформил заказ (SalespersonPerson).
Сделать без подзапросов.
*/

напишите здесь свое решение

/*
6. Все ид и имена клиентов и их контактные телефоны,
которые покупали товар "Chocolate frogs 250g".
Имя товара смотреть в таблице Warehouse.StockItems.
*/

напишите здесь свое решение
