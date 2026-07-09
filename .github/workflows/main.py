from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.uix.label import Label
from kivy.uix.button import Button
import random

class SafeIdiotApp(App):
    def build(self):
        # 레이아웃 설정
        self.layout = GridLayout(cols=1, padding=50, spacing=20)
        
        # 메인 메시지 창
        self.label = Label(
            text="You Are An Idiot! 🤪", 
            font_size='32sp',
            color=(1, 0, 0, 1) # 빨간색
        )
        self.layout.add_widget(self.label)
        
        # 1. 사용자를 킹받게 하는 장난 버튼
        self.fake_btn = Button(
            text="여기 눌러서 나가기", 
            font_size='20sp',
            background_color=(0.2, 0.6, 1, 1) # 파란색
        )
        self.fake_btn.bind(on_press=self.clown_user)
        self.layout.add_widget(self.fake_btn)
        
        # 2. 진짜로 앱을 닫아주는 탈출 버튼
        self.exit_btn = Button(
            text="진짜 종료 (진짜임)", 
            font_size='16sp',
            background_color=(0.4, 0.4, 0.4, 1) # 회색
        )
        self.exit_btn.bind(on_press=self.real_exit)
        self.layout.add_widget(self.exit_btn)
        
        return self.layout

    # 장난 버튼을 눌렀을 때 실행되는 함수
    def clown_user(self, instance):
        messages = [
            "속았지롱~? 🤪",
            "응 안 꺼져~ 🤫",
            "밑에 회색 버튼을 찾아봐! 👇",
            "탈출구를 열어두긴 했어 🏃‍♂️",
            "바보 소리 한 번 더 듣기! 💀"
        ]
        # 글자 내용과 크기를 랜덤으로 변경
        self.label.text = random.choice(messages)
        self.label.font_size = f"{random.randint(25, 40)}sp"

    # 진짜 종료 버튼을 눌렀을 때 실행되는 함수
    def real_exit(self, instance):
        self.stop() # Kivy 앱을 안전하게 정상 종료합니다.

if __name__ == '__main__':
    SafeIdiotApp().run()
