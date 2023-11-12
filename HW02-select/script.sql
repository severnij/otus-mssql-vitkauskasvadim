/*
�������� ������� �� ����� MS SQL Server Developer � OTUS.
������� "02 - �������� SELECT � ������� �������, JOIN".

������� ����������� � �������������� ���� ������ WideWorldImporters.

����� �� WideWorldImporters ����� ������� ������:
https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak

�������� WideWorldImporters �� Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- ������� - �������� ������� ��� ��������� ��������� ���� ������.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. ��� ������, � �������� ������� ���� "urgent" ��� �������� ���������� � "Animal".
�������: �� ������ (StockItemID), ������������ ������ (StockItemName).
�������: Warehouse.StockItems.
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
2. ����������� (Suppliers), � ������� �� ���� ������� �� ������ ������ (PurchaseOrders).
������� ����� JOIN, � ����������� ������� ������� �� �����.
�������: �� ���������� (SupplierID), ������������ ���������� (SupplierName).
�������: Purchasing.Suppliers, Purchasing.PurchaseOrders.
�� ����� �������� ������ JOIN ��������� ��������������.
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
3. ������ (Orders) � ����� ������ (UnitPrice) ����� 100$ 
���� ����������� ������ (Quantity) ������ ����� 20 ����
� �������������� ����� ������������ ����� ������ (PickingCompletedWhen).
�������:
* OrderID
* ���� ������ (OrderDate) � ������� ��.��.����
* �������� ������, � ������� ��� ������ �����
* ����� ��������, � ������� ��� ������ �����
* ����� ����, � ������� ��������� ���� ������ (������ ����� �� 4 ������)
* ��� ��������� (Customer)
�������� ������� ����� ������� � ������������ ��������,
��������� ������ 1000 � ��������� ��������� 100 �������.

���������� ������ ���� �� ������ ��������, ����� ����, ���� ������ (����� �� �����������).

�������: Sales.Orders, Sales.OrderLines, Sales.Customers.
*/

SELECT
	
	o.OrderID,
	CONVERT(varchar, o.OrderDate, 104) AS OrderDate,
	DATENAME(MONTH, o.OrderDate) AS OrderMonth,
	DATEPART(QUARTER, o.OrderDate) AS OrderQuarter,
	CASE 
		WHEN MONTH(o.OrderDate) BETWEEN 1 AND 4 THEN N'������ ����� ����'
		WHEN MONTH(o.OrderDate) BETWEEN 5 AND 8 THEN N'������ ����� ����'
		WHEN MONTH(o.OrderDate) BETWEEN 9 AND 12 THEN N'������ ����� ����'
	END AS '����� ����',
	c.CustomerName

FROM Sales.Orders AS o
	LEFT JOIN Sales.OrderLines AS ol ON o.OrderID = ol.OrderID
	LEFT JOIN Sales.Customers AS c ON o.CustomerID = c.CustomerID

WHERE
	(ol.UnitPrice > 100 OR ol.Quantity > 20) AND ol.PickingCompletedWhen IS NOT NULL;


DECLARE
	@pagesize	BIGINT = 100, -- ������ ��������.
	@pagenumber	BIGINT = 10; -- ����� ��������.

SELECT
	
	o.OrderID,
	CONVERT(varchar, o.OrderDate, 104) AS OrderDate,
	DATENAME(MONTH, o.OrderDate) AS OrderMonth,
	DATEPART(QUARTER, o.OrderDate) AS OrderQuarter,
	CASE 
		WHEN MONTH(o.OrderDate) BETWEEN 1 AND 4 THEN N'����� ���� 1'
		WHEN MONTH(o.OrderDate) BETWEEN 5 AND 8 THEN N'����� ���� 2'
		WHEN MONTH(o.OrderDate) BETWEEN 9 AND 12 THEN N'����� ���� 3'
	END AS [����� ����],
	c.CustomerName

FROM Sales.Orders AS o
	LEFT JOIN Sales.OrderLines AS ol ON o.OrderID = ol.OrderID
	LEFT JOIN Sales.Customers AS c ON o.CustomerID = c.CustomerID

WHERE
	(ol.UnitPrice > 100 OR ol.Quantity > 20) AND ol.PickingCompletedWhen IS NOT NULL
	
ORDER BY
	OrderQuarter, [����� ����], OrderDate

OFFSET @pagesize * @pagenumber ROWS FETCH NEXT @pagesize ROWS ONLY;

/*
4. ������ ����������� (Purchasing.Suppliers),
������� ������ ���� ��������� (ExpectedDeliveryDate) � ������ 2013 ����
� ��������� "Air Freight" ��� "Refrigerated Air Freight" (DeliveryMethodName)
� ������� ��������� (IsOrderFinalized).
�������:
* ������ �������� (DeliveryMethodName)
* ���� �������� (ExpectedDeliveryDate)
* ��� ����������
* ��� ����������� ���� ������������ ����� (ContactPerson)

�������: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.
*/

�������� ����� ���� �������

/*
5. ������ ��������� ������ (�� ���� �������) � ������ ������� � ������ ����������,
������� ������� ����� (SalespersonPerson).
������� ��� �����������.
*/

�������� ����� ���� �������

/*
6. ��� �� � ����� �������� � �� ���������� ��������,
������� �������� ����� "Chocolate frogs 250g".
��� ������ �������� � ������� Warehouse.StockItems.
*/

�������� ����� ���� �������
