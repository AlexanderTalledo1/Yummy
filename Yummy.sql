USE [master]
GO
/****** Object:  Database [Yummy]    Script Date: 20/01/2022 02:10:28 pm ******/
CREATE DATABASE [Yummy]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Yummy', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS02\MSSQL\DATA\Yummy.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Yummy_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS02\MSSQL\DATA\Yummy_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Yummy] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Yummy].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Yummy] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Yummy] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Yummy] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Yummy] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Yummy] SET ARITHABORT OFF 
GO
ALTER DATABASE [Yummy] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Yummy] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Yummy] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Yummy] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Yummy] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Yummy] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Yummy] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Yummy] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Yummy] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Yummy] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Yummy] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Yummy] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Yummy] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Yummy] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Yummy] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Yummy] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Yummy] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Yummy] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Yummy] SET  MULTI_USER 
GO
ALTER DATABASE [Yummy] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Yummy] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Yummy] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Yummy] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Yummy] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Yummy] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Yummy] SET QUERY_STORE = OFF
GO
USE [Yummy]
GO
/****** Object:  Table [dbo].[Cliente]    Script Date: 20/01/2022 02:10:28 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cliente](
	[C_IdCliente] [int] NOT NULL,
	[D_Nombre] [varchar](50) NOT NULL,
	[D_Apellido] [varchar](50) NOT NULL,
	[D_NombreUsuario] [varchar](50) NOT NULL,
	[T_Contrasenia] [varchar](50) NOT NULL,
	[N_Telefono] [int] NOT NULL,
	[Baneado] [bit] NULL,
 CONSTRAINT [Cliente_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdCliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Comprobante]    Script Date: 20/01/2022 02:10:28 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comprobante](
	[C_IdComprobante] [int] NOT NULL,
	[Cliente_C_IdCliente] [int] NOT NULL,
	[MedioPago_C_IdMedioPago] [int] NOT NULL,
	[F_Fecha] [date] NOT NULL,
	[M_MontoTotal] [money] NOT NULL,
	[Repartidor_C_IdRepartidor] [int] NULL,
	[Ubicacion_C_IdUbicacion] [int] NULL,
 CONSTRAINT [Comprobante_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdComprobante] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_MontoCliente]    Script Date: 20/01/2022 02:10:28 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[V_MontoCliente] as 
Select 
cl.C_IdCliente, sum(c.M_MontoTotal) as "MontoClientes"
from Comprobante c inner join Cliente cl on c.Cliente_C_IdCliente = cl.C_IdCliente
group by cl.C_IdCliente
GO
/****** Object:  UserDefinedFunction [dbo].[F_MejorCliente]    Script Date: 20/01/2022 02:10:28 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create function [dbo].[F_MejorCliente]()
returns table 
as 
return
Select 
cl.C_IdCliente,cl.D_Nombre,cl.D_Apellido, sum(c.M_MontoTotal) as "Monto total"
from Comprobante c inner join Cliente cl on c.Cliente_C_IdCliente = cl.C_IdCliente
group by cl.C_IdCliente,cl.D_Nombre,cl.D_Apellido
having (sum(c.M_MontoTotal))  = (select max(v.MontoClientes) from V_MontoCliente v)
GO
/****** Object:  Table [dbo].[Repartidor]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Repartidor](
	[C_IdRepartidor] [int] NOT NULL,
	[Documento_C_IdDocumento] [int] NOT NULL,
	[D_Nombre] [varchar](50) NOT NULL,
	[D_Apellido] [varchar](50) NOT NULL,
	[N_Telefono] [int] NOT NULL,
	[C_Documento] [varchar](20) NOT NULL,
	[Baneado] [bit] NULL,
 CONSTRAINT [Repartidor_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdRepartidor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[F_MejorRepartidor]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[F_MejorRepartidor]()
returns table
as
return
Select
r.C_IdRepartidor,r.D_Nombre,r.D_Apellido,
sum(c.M_MontoTotal) as "Total"
from
Repartidor r 
inner join Comprobante c on r.C_IdRepartidor = c.Repartidor_C_IdRepartidor
group by r.C_IdRepartidor,r.D_Nombre,r.D_Apellido
having (sum(c.M_MontoTotal)) = 

(select 
max(a.Total) from(Select
r.C_IdRepartidor,
sum(c.M_MontoTotal) as "Total"
from
Repartidor r 
inner join Comprobante c on r.C_IdRepartidor = c.Repartidor_C_IdRepartidor
group by r.C_IdRepartidor)a)
GO
/****** Object:  View [dbo].[Monto_Acumulado_Motorizados]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Monto_Acumulado_Motorizados] as 

Select
R.C_IdRepartidor, SUM(c.M_MontoTotal) as "Total"
from
Repartidor r left join Comprobante c on c.Repartidor_C_IdRepartidor = r.C_IdRepartidor
group by R.C_IdRepartidor
GO
/****** Object:  Table [dbo].[InfraccionxRepartidor]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InfraccionxRepartidor](
	[Repartidor_C_IdRepartidor] [int] NOT NULL,
	[Infraccion_C_IdInfraccion] [int] NOT NULL,
	[F_infraccion] [datetime] NOT NULL,
 CONSTRAINT [InfraccionxRepartidor_pk] PRIMARY KEY CLUSTERED 
(
	[F_infraccion] ASC,
	[Repartidor_C_IdRepartidor] ASC,
	[Infraccion_C_IdInfraccion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[F_Repartidor_Mayor_Cantidad_Infracciones]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[F_Repartidor_Mayor_Cantidad_Infracciones]()
returns table
return
select 
r.C_IdRepartidor,
r.D_Nombre,
r.D_Apellido,
COUNT(i.Infraccion_C_IdInfraccion) as "ContadorDeInfracciones"
from
Repartidor r 
inner join InfraccionxRepartidor i on r.C_IdRepartidor = i.Repartidor_C_IdRepartidor
group by 
r.C_IdRepartidor,
r.D_Apellido,
r.D_Nombre
having (COUNT(i.Infraccion_C_IdInfraccion)) = 

(Select max(a.ContadorDeInfracciones) 
from (
select r.C_IdRepartidor,
COUNT(i.Infraccion_C_IdInfraccion) as "ContadorDeInfracciones"
from Repartidor r inner join InfraccionxRepartidor i on r.C_IdRepartidor = i.Repartidor_C_IdRepartidor 
group by r.C_IdRepartidor )a)
GO
/****** Object:  Table [dbo].[InfraccionxCliente]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InfraccionxCliente](
	[Infraccion_C_IdInfraccion] [int] NOT NULL,
	[Cliente_C_IdCliente] [int] NOT NULL,
	[F_Infraccion] [datetime] NOT NULL,
 CONSTRAINT [InfraccionxCliente_pk] PRIMARY KEY CLUSTERED 
(
	[F_Infraccion] ASC,
	[Cliente_C_IdCliente] ASC,
	[Infraccion_C_IdInfraccion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[F_Cliente_Mayor_Cantidad_Infracciones]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[F_Cliente_Mayor_Cantidad_Infracciones]()
returns table
return
select c.C_IdCliente,c.D_Apellido,c.D_Nombre, count(i.Infraccion_C_IdInfraccion) as"ConteoDeInfracciones"
from Cliente c inner join InfraccionxCliente i on c.C_IdCliente = i.Cliente_C_IdCliente
group by c.C_IdCliente,c.D_Apellido,c.D_Nombre
having (count(i.Infraccion_C_IdInfraccion)) = 
(Select MAx(a.ConteoDeInfracciones) from 
(select c.C_IdCliente, count(i.Infraccion_C_IdInfraccion) as"ConteoDeInfracciones"
from Cliente c inner join InfraccionxCliente i on c.C_IdCliente = i.Cliente_C_IdCliente
group by c.C_IdCliente) a)
GO
/****** Object:  Table [dbo].[Bebida]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bebida](
	[D_Nombre] [varchar](50) NOT NULL,
	[D_Estado] [varchar](50) NOT NULL,
	[Producto_C_IdProducto] [int] NOT NULL,
 CONSTRAINT [Bebida_pk] PRIMARY KEY CLUSTERED 
(
	[Producto_C_IdProducto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Calificacion]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Calificacion](
	[C_IdCalificacion] [int] NOT NULL,
	[Q_Estrellas] [int] NOT NULL,
 CONSTRAINT [Calificacion_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdCalificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Carta]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Carta](
	[Producto_C_IdProducto] [int] NOT NULL,
	[Restaurante_C_IdRestaurante] [int] NOT NULL,
	[Promocion_C_IdPromocion] [int] NULL,
	[F_Vigente] [bit] NOT NULL,
 CONSTRAINT [Carta_pk] PRIMARY KEY CLUSTERED 
(
	[Producto_C_IdProducto] ASC,
	[Restaurante_C_IdRestaurante] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetallesComprobante]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetallesComprobante](
	[ComprobatePago_C_IdComprobante] [int] NOT NULL,
	[Carta_Producto_C_IdProducto] [int] NOT NULL,
	[Calificacion_C_IdCalificacion] [int] NOT NULL,
	[Carta_Restaurante_C_IdRestaurante] [int] NOT NULL,
	[Q_CantidadProducto] [int] NOT NULL,
 CONSTRAINT [DetallesComprobante_pk] PRIMARY KEY CLUSTERED 
(
	[Carta_Producto_C_IdProducto] ASC,
	[ComprobatePago_C_IdComprobante] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Documento]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Documento](
	[C_IdDocumento] [int] NOT NULL,
	[D_Nombre] [varchar](50) NOT NULL,
 CONSTRAINT [Documento_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdDocumento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Efectivo]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Efectivo](
	[C_IdEfectivo] [int] NOT NULL,
	[M_Monto] [money] NOT NULL,
 CONSTRAINT [Efectivo_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdEfectivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Entrada]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Entrada](
	[D_Nombre] [varchar](50) NOT NULL,
	[Producto_C_IdProducto] [int] NOT NULL,
 CONSTRAINT [Entrada_pk] PRIMARY KEY CLUSTERED 
(
	[Producto_C_IdProducto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstiloCocina]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstiloCocina](
	[C_IdEstilo] [int] NOT NULL,
	[D_Nombre] [varchar](50) NOT NULL,
	[T_Descripcion] [varchar](500) NOT NULL,
 CONSTRAINT [EstiloCocina_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdEstilo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstiloxRestaurante]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstiloxRestaurante](
	[Restaurante_C_IdRestaurante] [int] NOT NULL,
	[EstiloCocina_C_IdEstilo] [int] NOT NULL,
 CONSTRAINT [EstiloxRestaurante_pk] PRIMARY KEY CLUSTERED 
(
	[Restaurante_C_IdRestaurante] ASC,
	[EstiloCocina_C_IdEstilo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Incidente]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Incidente](
	[C_IdIncidente] [int] NOT NULL,
	[D_Nombre] [varchar](50) NOT NULL,
 CONSTRAINT [Incidente_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdIncidente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Infraccion]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Infraccion](
	[C_IdInfraccion] [int] NOT NULL,
	[D_Nombre] [nvarchar](50) NOT NULL,
	[Q_Grado] [int] NOT NULL,
 CONSTRAINT [Infraccion_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdInfraccion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Local]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Local](
	[C_IdLocal] [int] NOT NULL,
	[Restaurante_C_IdRestaurante] [int] NOT NULL,
	[N_Telefono] [int] NOT NULL,
	[T_Direccion] [varchar](100) NOT NULL,
 CONSTRAINT [Local_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdLocal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedioPago]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedioPago](
	[C_IdMedioPago] [int] NOT NULL,
	[Efectivo_C_IdEfectivo] [int] NULL,
	[Tarjeta_C_IdTarjeta] [int] NULL,
 CONSTRAINT [MedioPago_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdMedioPago] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PlatoPrincipal]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlatoPrincipal](
	[D_Nombre] [varchar](50) NOT NULL,
	[Producto_C_IdProducto] [int] NOT NULL,
 CONSTRAINT [PlatoPrincipal_pk] PRIMARY KEY CLUSTERED 
(
	[Producto_C_IdProducto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Postre]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Postre](
	[D_Nombre] [varchar](50) NOT NULL,
	[Producto_C_IdProducto] [int] NOT NULL,
 CONSTRAINT [Postre_pk] PRIMARY KEY CLUSTERED 
(
	[Producto_C_IdProducto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Producto]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Producto](
	[C_IdProducto] [int] NOT NULL,
	[M_Precio] [money] NOT NULL,
 CONSTRAINT [Producto_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdProducto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Promocion]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Promocion](
	[C_IdPromocion] [int] NOT NULL,
	[Tipo_Promocion_C_IdTipoPromocion] [int] NOT NULL,
	[Restaurante_C_IdRestaurante] [int] NOT NULL,
	[D_Nombre] [varchar](50) NOT NULL,
	[Q_CantidadDescuento] [int] NOT NULL,
 CONSTRAINT [Promocion_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdPromocion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Restaurante]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Restaurante](
	[C_IdRestaurante] [int] NOT NULL,
	[D_Nombre] [varchar](50) NOT NULL,
	[C_RUC] [bigint] NOT NULL,
 CONSTRAINT [Restaurante_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdRestaurante] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tarjeta]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tarjeta](
	[C_IdTarjeta] [int] NOT NULL,
	[Cliente_C_IdCliente] [int] NOT NULL,
	[N_Numero] [bigint] NOT NULL,
	[B_Tipo_Tarjeta] [bit] NOT NULL,
 CONSTRAINT [Tarjeta_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdTarjeta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tipo_Promocion]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tipo_Promocion](
	[C_IdTipoPromocion] [int] NOT NULL,
	[D_Nombre] [nvarchar](50) NOT NULL,
 CONSTRAINT [Tipo_Promocion_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdTipoPromocion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ubicacion]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ubicacion](
	[C_IdUbicacion] [int] NOT NULL,
	[D_Direccion] [varchar](50) NOT NULL,
	[T_Descripcion] [varchar](500) NOT NULL,
 CONSTRAINT [Ubicacion_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdUbicacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Vehiculo]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehiculo](
	[C_IdVehiculo] [int] NOT NULL,
	[Repartidor_C_IdRepartidor] [int] NOT NULL,
	[C_Placa] [varchar](10) NOT NULL,
 CONSTRAINT [Vehiculo_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdVehiculo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VehiculoxIncidente]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VehiculoxIncidente](
	[Incidente_C_IdIncidente] [int] NOT NULL,
	[Vehiculo_C_IdVehiculo] [int] NOT NULL,
	[F_Fecha] [datetime] NOT NULL,
	[T_Descripcion] [varchar](500) NOT NULL,
 CONSTRAINT [VehiculoxIncidente_pk] PRIMARY KEY CLUSTERED 
(
	[Incidente_C_IdIncidente] ASC,
	[Vehiculo_C_IdVehiculo] ASC,
	[F_Fecha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Zona]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Zona](
	[C_IdZona] [int] NOT NULL,
	[D_Distrito] [varchar](50) NOT NULL,
 CONSTRAINT [Zona_pk] PRIMARY KEY CLUSTERED 
(
	[C_IdZona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ZonaxRepartidor]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ZonaxRepartidor](
	[Repartidor_C_IdRepartidor] [int] NOT NULL,
	[Zona_C_IdZona] [int] NOT NULL,
	[F_Actividad] [date] NOT NULL,
 CONSTRAINT [ZonaxRepartidor_pk] PRIMARY KEY CLUSTERED 
(
	[Repartidor_C_IdRepartidor] ASC,
	[Zona_C_IdZona] ASC,
	[F_Actividad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Bebida]  WITH CHECK ADD  CONSTRAINT [Bedida_Producto] FOREIGN KEY([Producto_C_IdProducto])
REFERENCES [dbo].[Producto] ([C_IdProducto])
GO
ALTER TABLE [dbo].[Bebida] CHECK CONSTRAINT [Bedida_Producto]
GO
ALTER TABLE [dbo].[Carta]  WITH CHECK ADD  CONSTRAINT [Carta_Producto] FOREIGN KEY([Producto_C_IdProducto])
REFERENCES [dbo].[Producto] ([C_IdProducto])
GO
ALTER TABLE [dbo].[Carta] CHECK CONSTRAINT [Carta_Producto]
GO
ALTER TABLE [dbo].[Carta]  WITH CHECK ADD  CONSTRAINT [Carta_Promocion] FOREIGN KEY([Promocion_C_IdPromocion])
REFERENCES [dbo].[Promocion] ([C_IdPromocion])
GO
ALTER TABLE [dbo].[Carta] CHECK CONSTRAINT [Carta_Promocion]
GO
ALTER TABLE [dbo].[Carta]  WITH CHECK ADD  CONSTRAINT [Menu_Restaurante] FOREIGN KEY([Restaurante_C_IdRestaurante])
REFERENCES [dbo].[Restaurante] ([C_IdRestaurante])
GO
ALTER TABLE [dbo].[Carta] CHECK CONSTRAINT [Menu_Restaurante]
GO
ALTER TABLE [dbo].[Comprobante]  WITH CHECK ADD  CONSTRAINT [Comprobante_Repartidor] FOREIGN KEY([Repartidor_C_IdRepartidor])
REFERENCES [dbo].[Repartidor] ([C_IdRepartidor])
GO
ALTER TABLE [dbo].[Comprobante] CHECK CONSTRAINT [Comprobante_Repartidor]
GO
ALTER TABLE [dbo].[Comprobante]  WITH CHECK ADD  CONSTRAINT [Comprobante_Ubicacion] FOREIGN KEY([Ubicacion_C_IdUbicacion])
REFERENCES [dbo].[Ubicacion] ([C_IdUbicacion])
GO
ALTER TABLE [dbo].[Comprobante] CHECK CONSTRAINT [Comprobante_Ubicacion]
GO
ALTER TABLE [dbo].[Comprobante]  WITH CHECK ADD  CONSTRAINT [ComprobatePago_Cliente] FOREIGN KEY([Cliente_C_IdCliente])
REFERENCES [dbo].[Cliente] ([C_IdCliente])
GO
ALTER TABLE [dbo].[Comprobante] CHECK CONSTRAINT [ComprobatePago_Cliente]
GO
ALTER TABLE [dbo].[Comprobante]  WITH CHECK ADD  CONSTRAINT [ComprobatePago_MedioPago] FOREIGN KEY([MedioPago_C_IdMedioPago])
REFERENCES [dbo].[MedioPago] ([C_IdMedioPago])
GO
ALTER TABLE [dbo].[Comprobante] CHECK CONSTRAINT [ComprobatePago_MedioPago]
GO
ALTER TABLE [dbo].[DetallesComprobante]  WITH CHECK ADD  CONSTRAINT [DetallesPedido_Carta] FOREIGN KEY([Carta_Producto_C_IdProducto], [Carta_Restaurante_C_IdRestaurante])
REFERENCES [dbo].[Carta] ([Producto_C_IdProducto], [Restaurante_C_IdRestaurante])
GO
ALTER TABLE [dbo].[DetallesComprobante] CHECK CONSTRAINT [DetallesPedido_Carta]
GO
ALTER TABLE [dbo].[DetallesComprobante]  WITH CHECK ADD  CONSTRAINT [Pedido_Calificacion] FOREIGN KEY([Calificacion_C_IdCalificacion])
REFERENCES [dbo].[Calificacion] ([C_IdCalificacion])
GO
ALTER TABLE [dbo].[DetallesComprobante] CHECK CONSTRAINT [Pedido_Calificacion]
GO
ALTER TABLE [dbo].[DetallesComprobante]  WITH CHECK ADD  CONSTRAINT [Pedido_ComprobatePago] FOREIGN KEY([ComprobatePago_C_IdComprobante])
REFERENCES [dbo].[Comprobante] ([C_IdComprobante])
GO
ALTER TABLE [dbo].[DetallesComprobante] CHECK CONSTRAINT [Pedido_ComprobatePago]
GO
ALTER TABLE [dbo].[Entrada]  WITH CHECK ADD  CONSTRAINT [Entrada_Producto] FOREIGN KEY([Producto_C_IdProducto])
REFERENCES [dbo].[Producto] ([C_IdProducto])
GO
ALTER TABLE [dbo].[Entrada] CHECK CONSTRAINT [Entrada_Producto]
GO
ALTER TABLE [dbo].[EstiloxRestaurante]  WITH CHECK ADD  CONSTRAINT [EstiloCocinaxRestaurante_Restaurante] FOREIGN KEY([Restaurante_C_IdRestaurante])
REFERENCES [dbo].[Restaurante] ([C_IdRestaurante])
GO
ALTER TABLE [dbo].[EstiloxRestaurante] CHECK CONSTRAINT [EstiloCocinaxRestaurante_Restaurante]
GO
ALTER TABLE [dbo].[EstiloxRestaurante]  WITH CHECK ADD  CONSTRAINT [EstiloxRestaurante_EstiloCocina] FOREIGN KEY([EstiloCocina_C_IdEstilo])
REFERENCES [dbo].[EstiloCocina] ([C_IdEstilo])
GO
ALTER TABLE [dbo].[EstiloxRestaurante] CHECK CONSTRAINT [EstiloxRestaurante_EstiloCocina]
GO
ALTER TABLE [dbo].[InfraccionxCliente]  WITH CHECK ADD  CONSTRAINT [InfraccionxCliente_Cliente] FOREIGN KEY([Cliente_C_IdCliente])
REFERENCES [dbo].[Cliente] ([C_IdCliente])
GO
ALTER TABLE [dbo].[InfraccionxCliente] CHECK CONSTRAINT [InfraccionxCliente_Cliente]
GO
ALTER TABLE [dbo].[InfraccionxCliente]  WITH CHECK ADD  CONSTRAINT [InfraccionxCliente_Infraccion] FOREIGN KEY([Infraccion_C_IdInfraccion])
REFERENCES [dbo].[Infraccion] ([C_IdInfraccion])
GO
ALTER TABLE [dbo].[InfraccionxCliente] CHECK CONSTRAINT [InfraccionxCliente_Infraccion]
GO
ALTER TABLE [dbo].[InfraccionxRepartidor]  WITH CHECK ADD  CONSTRAINT [InfraccionxRepartidor_Infraccion] FOREIGN KEY([Infraccion_C_IdInfraccion])
REFERENCES [dbo].[Infraccion] ([C_IdInfraccion])
GO
ALTER TABLE [dbo].[InfraccionxRepartidor] CHECK CONSTRAINT [InfraccionxRepartidor_Infraccion]
GO
ALTER TABLE [dbo].[InfraccionxRepartidor]  WITH CHECK ADD  CONSTRAINT [InfraccionxRepartidor_Repartidor] FOREIGN KEY([Repartidor_C_IdRepartidor])
REFERENCES [dbo].[Repartidor] ([C_IdRepartidor])
GO
ALTER TABLE [dbo].[InfraccionxRepartidor] CHECK CONSTRAINT [InfraccionxRepartidor_Repartidor]
GO
ALTER TABLE [dbo].[Local]  WITH CHECK ADD  CONSTRAINT [Local_Restaurante] FOREIGN KEY([Restaurante_C_IdRestaurante])
REFERENCES [dbo].[Restaurante] ([C_IdRestaurante])
GO
ALTER TABLE [dbo].[Local] CHECK CONSTRAINT [Local_Restaurante]
GO
ALTER TABLE [dbo].[MedioPago]  WITH CHECK ADD  CONSTRAINT [MedioPago_Efectivo] FOREIGN KEY([Efectivo_C_IdEfectivo])
REFERENCES [dbo].[Efectivo] ([C_IdEfectivo])
GO
ALTER TABLE [dbo].[MedioPago] CHECK CONSTRAINT [MedioPago_Efectivo]
GO
ALTER TABLE [dbo].[MedioPago]  WITH CHECK ADD  CONSTRAINT [MedioPago_Tarjeta] FOREIGN KEY([Tarjeta_C_IdTarjeta])
REFERENCES [dbo].[Tarjeta] ([C_IdTarjeta])
GO
ALTER TABLE [dbo].[MedioPago] CHECK CONSTRAINT [MedioPago_Tarjeta]
GO
ALTER TABLE [dbo].[PlatoPrincipal]  WITH CHECK ADD  CONSTRAINT [PlatoPrincipal_Producto] FOREIGN KEY([Producto_C_IdProducto])
REFERENCES [dbo].[Producto] ([C_IdProducto])
GO
ALTER TABLE [dbo].[PlatoPrincipal] CHECK CONSTRAINT [PlatoPrincipal_Producto]
GO
ALTER TABLE [dbo].[Postre]  WITH CHECK ADD  CONSTRAINT [Postre_Producto] FOREIGN KEY([Producto_C_IdProducto])
REFERENCES [dbo].[Producto] ([C_IdProducto])
GO
ALTER TABLE [dbo].[Postre] CHECK CONSTRAINT [Postre_Producto]
GO
ALTER TABLE [dbo].[Promocion]  WITH CHECK ADD  CONSTRAINT [Promocion_Restaurante] FOREIGN KEY([Restaurante_C_IdRestaurante])
REFERENCES [dbo].[Restaurante] ([C_IdRestaurante])
GO
ALTER TABLE [dbo].[Promocion] CHECK CONSTRAINT [Promocion_Restaurante]
GO
ALTER TABLE [dbo].[Promocion]  WITH CHECK ADD  CONSTRAINT [Promocion_Tipo_Promocion] FOREIGN KEY([Tipo_Promocion_C_IdTipoPromocion])
REFERENCES [dbo].[Tipo_Promocion] ([C_IdTipoPromocion])
GO
ALTER TABLE [dbo].[Promocion] CHECK CONSTRAINT [Promocion_Tipo_Promocion]
GO
ALTER TABLE [dbo].[Repartidor]  WITH CHECK ADD  CONSTRAINT [Repartidor_Documento] FOREIGN KEY([Documento_C_IdDocumento])
REFERENCES [dbo].[Documento] ([C_IdDocumento])
GO
ALTER TABLE [dbo].[Repartidor] CHECK CONSTRAINT [Repartidor_Documento]
GO
ALTER TABLE [dbo].[Tarjeta]  WITH CHECK ADD  CONSTRAINT [Tarjeta_Cliente] FOREIGN KEY([Cliente_C_IdCliente])
REFERENCES [dbo].[Cliente] ([C_IdCliente])
GO
ALTER TABLE [dbo].[Tarjeta] CHECK CONSTRAINT [Tarjeta_Cliente]
GO
ALTER TABLE [dbo].[Vehiculo]  WITH CHECK ADD  CONSTRAINT [Vehiculo_Repartidor] FOREIGN KEY([Repartidor_C_IdRepartidor])
REFERENCES [dbo].[Repartidor] ([C_IdRepartidor])
GO
ALTER TABLE [dbo].[Vehiculo] CHECK CONSTRAINT [Vehiculo_Repartidor]
GO
ALTER TABLE [dbo].[VehiculoxIncidente]  WITH CHECK ADD  CONSTRAINT [VehiculoxIncidente_Incidente] FOREIGN KEY([Incidente_C_IdIncidente])
REFERENCES [dbo].[Incidente] ([C_IdIncidente])
GO
ALTER TABLE [dbo].[VehiculoxIncidente] CHECK CONSTRAINT [VehiculoxIncidente_Incidente]
GO
ALTER TABLE [dbo].[VehiculoxIncidente]  WITH CHECK ADD  CONSTRAINT [VehiculoxIncidente_Vehiculo] FOREIGN KEY([Vehiculo_C_IdVehiculo])
REFERENCES [dbo].[Vehiculo] ([C_IdVehiculo])
GO
ALTER TABLE [dbo].[VehiculoxIncidente] CHECK CONSTRAINT [VehiculoxIncidente_Vehiculo]
GO
ALTER TABLE [dbo].[ZonaxRepartidor]  WITH CHECK ADD  CONSTRAINT [ZonaxRepartidor_Repartidor] FOREIGN KEY([Repartidor_C_IdRepartidor])
REFERENCES [dbo].[Repartidor] ([C_IdRepartidor])
GO
ALTER TABLE [dbo].[ZonaxRepartidor] CHECK CONSTRAINT [ZonaxRepartidor_Repartidor]
GO
ALTER TABLE [dbo].[ZonaxRepartidor]  WITH CHECK ADD  CONSTRAINT [ZonaxRepartidor_Zona] FOREIGN KEY([Zona_C_IdZona])
REFERENCES [dbo].[Zona] ([C_IdZona])
GO
ALTER TABLE [dbo].[ZonaxRepartidor] CHECK CONSTRAINT [ZonaxRepartidor_Zona]
GO
/****** Object:  StoredProcedure [dbo].[sp_5_productos_mas_vendidos]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_5_productos_mas_vendidos]
as
begin
Select Top(5)
d.Carta_Producto_C_IdProducto,
count(c.Producto_C_IdProducto) as "ConteoProductos"
from
DetallesComprobante d 
inner join Carta c on d.Carta_Producto_C_IdProducto = c.Producto_C_IdProducto
group by d.Carta_Producto_C_IdProducto
order by 2 desc
end
GO
/****** Object:  StoredProcedure [dbo].[spReportesDeVentasPorMesAño]    Script Date: 20/01/2022 02:10:29 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spReportesDeVentasPorMesAño]
	@Año as int,
	@Mes as int
AS
BEGIN
	Select 
	@Año as "Año",
	@Mes as "Mes",
	COUNT(C.C_IdComprobante) as "Conteo de ventas",
	ISNULL(SUM(DC.Q_CantidadProducto*P.M_Precio),0) as "Total Ventas"
	from 
	Comprobante C 
	inner join DetallesComprobante DC on C.C_IdComprobante = DC.ComprobatePago_C_IdComprobante
	inner join Producto P on P.C_IdProducto = DC.Carta_Producto_C_IdProducto
	Where 
	YEAR(C.F_Fecha) = @Año And
	MONTH(C.F_Fecha)=@Mes
END
GO
USE [master]
GO
ALTER DATABASE [Yummy] SET  READ_WRITE 
GO
