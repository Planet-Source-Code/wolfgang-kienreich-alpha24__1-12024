VERSION 5.00
Begin VB.Form fAlpha24Demo 
   AutoRedraw      =   -1  'True
   BackColor       =   &H00C0C0C0&
   BorderStyle     =   0  'None
   Caption         =   "Alpha24 Demo"
   ClientHeight    =   6000
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   6735
   BeginProperty Font 
      Name            =   "Arial"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H00404040&
   KeyPreview      =   -1  'True
   LinkTopic       =   "Alpha24"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   400
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   449
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.PictureBox picLight 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   300
      Left            =   5895
      Picture         =   "fAlpha24Demo.frx":0000
      ScaleHeight     =   20
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   20
      TabIndex        =   9
      Top             =   2805
      Width           =   300
   End
   Begin VB.PictureBox picHover 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   300
      Left            =   5895
      Picture         =   "fAlpha24Demo.frx":04F2
      ScaleHeight     =   20
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   20
      TabIndex        =   10
      Top             =   3150
      Width           =   300
   End
   Begin VB.PictureBox picRestore 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H00000000&
      Height          =   150
      Left            =   5955
      ScaleHeight     =   10
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   12
      TabIndex        =   3
      Top             =   120
      Width           =   180
   End
   Begin VB.PictureBox picImageClip 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H00000000&
      Height          =   135
      Left            =   6240
      ScaleHeight     =   9
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   9
      TabIndex        =   2
      Top             =   120
      Width           =   135
   End
   Begin VB.PictureBox picLightCone 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H00000000&
      Height          =   135
      Left            =   6480
      ScaleHeight     =   9
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   9
      TabIndex        =   0
      Top             =   120
      Width           =   135
   End
   Begin VB.Label lblButton 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      ForeColor       =   &H80000008&
      Height          =   510
      Index           =   4
      Left            =   5790
      TabIndex        =   8
      Top             =   4815
      Width           =   510
   End
   Begin VB.Label lblButton 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      ForeColor       =   &H80000008&
      Height          =   510
      Index           =   3
      Left            =   5790
      TabIndex        =   7
      Top             =   3780
      Width           =   510
   End
   Begin VB.Label lblButton 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      ForeColor       =   &H80000008&
      Height          =   510
      Index           =   2
      Left            =   5790
      TabIndex        =   6
      Top             =   3030
      Width           =   510
   End
   Begin VB.Label lblButton 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      ForeColor       =   &H80000008&
      Height          =   510
      Index           =   1
      Left            =   5790
      TabIndex        =   5
      Top             =   2265
      Width           =   510
   End
   Begin VB.Label lblButton 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      ForeColor       =   &H80000008&
      Height          =   510
      Index           =   0
      Left            =   5805
      TabIndex        =   4
      Top             =   1515
      Width           =   510
   End
   Begin VB.Label lblMove 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      ForeColor       =   &H00000000&
      Height          =   855
      Left            =   15
      MousePointer    =   15  'Size All
      TabIndex        =   1
      Top             =   30
      Width           =   3015
   End
End
Attribute VB_Name = "fAlpha24Demo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
   
' API Declarations to make the demo look cool ...
    Private Declare Function CreatePolygonRgn Lib "gdi32" (lpPoint As POINTAPI, ByVal nCount As Long, ByVal nPolyFillMode As Long) As Long
    Private Declare Function SetWindowRgn Lib "user32" (ByVal hWnd As Long, ByVal hRgn As Long, ByVal bRedraw As Boolean) As Long
    Private Declare Function timeGetTime Lib "winmm.dll" () As Long
    Private Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long

' Datatypes to make the demo look cool ...

    ' API Point datatype for polygon creation
    Private Type POINTAPI
        X As Long
        Y As Long
    End Type
        
' API Declarations for alphablending environment...
    Private Declare Function GetObjectAPI Lib "gdi32" Alias "GetObjectA" (ByVal hObject As Long, ByVal nCount As Long, lpObject As Any) As Long
    Private Declare Function GetDeviceCaps Lib "gdi32" (ByVal hdc As Long, ByVal nIndex As Long) As Long

' Declaration for the alphablending lib... MODIFY TO FIT YOUR PATH IF NECESSARY
    Private Declare Sub Alpha24 Lib "alpha24.dll" (ByVal lpSrc As Long, ByVal nSrcX As Long, ByVal nSrcY As Long, ByVal nSrcWidth As Long, ByVal nSrcHeight As Long, ByVal nSrcPitch As Long, ByVal lpDst As Long, ByVal nDstX As Long, ByVal nDstY As Long, ByVal nDstPitch As Long, ByVal nMode As Long, ByVal nAmount As Long)

' Datatypes for alphablending ...

    ' Bitmap descriptor
    Private Type BITMAP
        bmType As Long              ' Type of bitmap
        bmWidth As Long             ' Bitmap width in pixel
        bmHeight As Long            ' Bitmap height in pixel
        bmWidthBytes As Long        ' Bitmap width in bytes, like the pitch of a DirectDraw surface
        bmPlanes As Integer         ' Color depth of bitmap
        bmBitsPixel As Integer      ' Bits per pixel, must be 24 or we will terminate
        bmBits As Long              ' This is the pointer to our bitmap data
    End Type

' Global variables

    Private bInitialized As Boolean ' Main loop started?
    Private bTerminating As Boolean ' Main loop terminating?
    
    Private dMouseStart As POINTAPI  ' Offset for window movement on screen
    Private dWindowStart As POINTAPI ' Offset for window movement on screen
    Private dPosition As POINTAPI    ' Current drawing position
    Private dMotion As POINTAPI      ' Current drawing position change
    Private nStyle As Long           ' Current drawing style
    Private nAmount As Long          ' current drawing amount
    Private nCurrentArea As Long     ' Current Area mouse is in
    
' FORM_ACTIVATE: Main program loop
Private Sub Form_Activate()
    
    Dim nNextFrameTime As Long          ' Frame timing: Holds the time the next frame is displayed
    
    Dim MySrc As BITMAP                 ' Source bitmap for rendering
    Dim MyDst As BITMAP                 ' Destination bitmap for rendering
    
    ' Check initialization state, start main loop if not already running
    If Not bInitialized Then
    
        ' Set initalization state
        bInitialized = True
        
        ' Run main loop
        Do
        
            Me.picHover.Visible = (nCurrentArea <> 9)
            Me.picHover.Top = 108 + nCurrentArea * 50 + IIf(nCurrentArea = 4, 20, 0)
            Me.picLight.Top = 108 + nStyle * 50
        
            ' Set next frame time: Try to achieve 50fps
            nNextFrameTime = timeGetTime + 20
                                    
            ' Restore
            GetObjectAPI Me.picRestore.Picture, Len(MySrc), MySrc
            GetObjectAPI Me.Picture, Len(MyDst), MyDst
            Alpha24 MySrc.bmBits, dPosition.X, dPosition.Y, 128 * 3, 128, MySrc.bmWidthBytes, MyDst.bmBits, dPosition.X, dPosition.Y, MyDst.bmWidthBytes, 3, 0
            
            ' Do movement of effect area
            dPosition.X = dPosition.X + dMotion.X
            dPosition.Y = dPosition.Y + dMotion.Y
            If Rnd > 0.99 Then
                If Rnd > 0.5 Then
                    dMotion.X = -dMotion.X
                Else
                    dMotion.Y = -dMotion.Y
                End If
            ElseIf dPosition.X > Me.picLight.Left - 148 Then
                dMotion.X = -dMotion.X
            ElseIf dPosition.X < 20 Then
                dMotion.X = -dMotion.X
            ElseIf dPosition.Y > Me.Height \ Screen.TwipsPerPixelY - 148 Then
                dMotion.Y = -dMotion.Y
            ElseIf dPosition.Y < 20 Then
                dMotion.Y = -dMotion.Y
            End If
            
            ' Render
            GetObjectAPI IIf(nStyle = 3, Me.picImageClip.Picture, Me.picLightCone.Picture), Len(MySrc), MySrc
            GetObjectAPI Me.Picture, Len(MyDst), MyDst
            Alpha24 MySrc.bmBits, 0, 0, MySrc.bmWidthBytes, MySrc.bmHeight, MySrc.bmWidthBytes, MyDst.bmBits, dPosition.X, dPosition.Y, MyDst.bmWidthBytes, IIf(nStyle > 2, 2, nStyle), nAmount
            
            ' Redraw window
            Me.Refresh
            
            ' React to user input
            Do
                DoEvents
            Loop Until timeGetTime > nNextFrameTime
            
        Loop Until bTerminating
        
        ' We're finished: Cleanup and leave
        Unload Me
        
    End If
    
End Sub


' FORM_CLICK: React to user keyboard input
Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
    
    ' Exit main loop
    bTerminating = (KeyCode = vbKeyEscape)
    
End Sub

' FORM_LOAD: Initialize program
Private Sub Form_Load()

    Dim dPolyPoint(0 To 6) As POINTAPI  ' Our polygon definition
    Dim nPointIndex As Long             ' Index to run over polygon data
    Dim nPolyRegion As Long             ' Handle to polygon region
    
    ' Create polygon data for window shape
    dPolyPoint(0).X = 0
    dPolyPoint(0).Y = 0
    dPolyPoint(1).X = 200
    dPolyPoint(1).Y = 0
    dPolyPoint(2).X = 250
    dPolyPoint(2).Y = 50
    dPolyPoint(3).X = 447
    dPolyPoint(3).Y = 50
    dPolyPoint(4).X = 447
    dPolyPoint(4).Y = 373
    dPolyPoint(5).X = 423
    dPolyPoint(5).Y = 397
    dPolyPoint(6).X = 0
    dPolyPoint(6).Y = 397
    
    ' Adapt polygon data to match window position
    For nPointIndex = 0 To UBound(dPolyPoint)
        With dPolyPoint(nPointIndex)
            .X = .X + Me.Left / Screen.TwipsPerPixelX
            .Y = .Y + Me.Top / Screen.TwipsPerPixelY
        End With
    Next
    
    ' Create region
    nPolyRegion = CreatePolygonRgn(dPolyPoint(0), 7, 0)
    
    ' Set region to window
    SetWindowRgn Me.hWnd, nPolyRegion, True
    
    ' Initialize light cone and image clip
    Set Me.picLightCone = LoadPicture(App.Path + "\lightcone.bmp")
    Set Me.picImageClip = LoadPicture(App.Path + "\imageclip.bmp")
    
    ' Initialize form background and restore (backbuffer) picture
    Set Me.Picture = LoadPicture(App.Path + "\falpha24demo.bmp")
    Set Me.picRestore.Picture = LoadPicture(App.Path + "\falpha24demo.bmp")
    
    ' Set initial position and motion
    dPosition.X = 20
    dPosition.Y = 20
    dMotion.X = 5
    dMotion.Y = 5
    
    ' Set initial style and amount
    nStyle = 0
    nAmount = 30
    
End Sub

' FORM_MOUSEMOVE: Set current area mouse is in
Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    nCurrentArea = 9
End Sub

' FORM_UNLOAD: Terminate program
Private Sub Form_Unload(Cancel As Integer)

    ' Terminate program
    End
    
End Sub

' LBLBUTTON_CLICK: Button behavior
Private Sub lblButton_Click(Index As Integer)
    Select Case Index
        Case 0
            nStyle = 0
        Case 1
            nStyle = 1
        Case 2
            nStyle = 2
        Case 3
            nStyle = 3
        Case 4
            bTerminating = True
    End Select
End Sub

' LBLBUTTON_MOUSEMOVE: Set current area mouse is in
Private Sub lblButton_MouseMove(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
    nCurrentArea = Index
End Sub

' LBLMOVE_MOUSEDOWN: Remember window and mouse start coordinates
Private Sub lblMove_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    
    ' Only move with left button pressed...
    If Button = 1 Then
        
        ' Get mouse and window position
        GetCursorPos dMouseStart
        dWindowStart.X = Me.Left \ Screen.TwipsPerPixelX
        dWindowStart.Y = Me.Top \ Screen.TwipsPerPixelY
        
    End If
    
End Sub


' LBLMOVE_MOUSEDOWN: Adjust window to current coordinates of mouse
Private Sub lblMove_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    
    ' Only move with left button pressed...
    If Button = 1 Then
        
        Dim dMouseNow As POINTAPI       ' Hold current mouse position
        Dim dWindowNow As POINTAPI      ' Hold current window position
        
        ' Get mouse and window position
        GetCursorPos dMouseNow
        dWindowNow.X = Me.Left \ Screen.TwipsPerPixelX
        dWindowNow.Y = Me.Top \ Screen.TwipsPerPixelY
        
        ' Set window to new position
        Me.Left = (dWindowStart.X + (dMouseNow.X - dMouseStart.X)) * Screen.TwipsPerPixelX
        Me.Top = (dWindowStart.Y + (dMouseNow.Y - dMouseStart.Y)) * Screen.TwipsPerPixelY
        
    End If
    
End Sub

' PICHOVER_CLICK: Set current style if click on hover
Private Sub picHover_Click()

    Select Case (Me.picHover.Top - 108 - IIf(nCurrentArea = 4, 20, 0)) \ 50
        Case 0
            nStyle = 0
        Case 1
            nStyle = 1
        Case 2
            nStyle = 2
        Case 3
            nStyle = 3
        Case 4
            bTerminating = True
    End Select

End Sub
