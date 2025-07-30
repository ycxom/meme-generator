import asyncio

from meme_generator.config import meme_config
from meme_generator.exception import MemeFeedback
from meme_generator.log import setup_logger
from meme_generator.utils import translate


async def main():
    """
    测试翻译功能的脚本
    """
    setup_logger()

    text_to_translate = "Hello, world!"
    target_language = "zh"

    print("--- 开始测试翻译功能 ---")
    print(f"当前翻译服务类型: {meme_config.translate.type}")
    print(f"待翻译文本: '{text_to_translate}'")
    print(f"目标语言: {target_language}")
    print("------------------------")

    try:
        # 调用翻译函数
        translated_text = translate(
            text_to_translate, lang_from="auto", lang_to=target_language
        )
        print("\n翻译成功！")
        print(f"翻译结果: '{translated_text}'\n")

    except MemeFeedback as e:
        print(f"\n翻译失败！错误信息: {e.message}\n")
    except Exception as e:
        print(f"\n发生未知错误: {e}\n")


if __name__ == "__main__":
    asyncio.run(main())