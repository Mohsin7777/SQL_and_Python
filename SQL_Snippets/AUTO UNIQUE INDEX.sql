CREATE TABLE [dbo].[TEST_4_APPLE_MASTER_AUDIT_FINAL](
	PURCHASE_ORDER NUMERIC IDENTITY (1000000000001,1),
	PRIMARY KEY (PURCHASE_ORDER),
	[IMEI] [varchar](20) NULL,
	[BAN_AT_ADD] [numeric](20, 0) NULL,
	[CTN_AT_ADD] [varchar](20) NULL,
	[EFFECTIVE_DATE] [datetime] NULL,
	[BILL_LANGUAGE] [char](2) NULL,
	[LAST_BUSINESS_NAME] [varchar](60) NULL,
	[FIRST_NAME] [varchar](32) NULL,
	[MIDDLE_INITIAL] [varchar](32) NULL,
	[NAME_TITLE] [varchar](5) NULL,
	[ADR_PRIMARY_LN] [varchar](40) NULL,
	[ADR_CITY] [varchar](32) NULL,
	[ADR_PROV_CODE] [varchar](50) NULL,
	[ADR_POSTAL_CODE] [varchar](50) NULL,
	[CONTACT_TELNO] [char](10) NULL,
	[EMAIL_ADDRESS] [varchar](80) NULL,
	[HOME_TELNO] [char](10) NULL,
	[OTHER_TELNO] [char](10) NULL,
	[WORK_TELNO] [char](10) NULL,
	[WORK_TN_EXTNO] [char](5) NULL,
	[PULL_DATE] [date] NULL,
	[HUP_SWAP] [date] NULL,
	[ACTIVATION] [date] NULL,
	[ACT_CHANGE] [date] NULL,
	[CANCEL_DATE] [date] NULL,
	[UPDATE_DATE] [date] NULL,
	
)