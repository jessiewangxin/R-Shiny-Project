#reading in data 
airbnb<-read.csv('./Data/listings.csv')

#loading libraries
library(shiny)
library(shinydashboard)
library(DT)
library(leaflet)
library(dplyr)
library(plotly)
library(viridis)