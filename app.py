import sys
import json
sys.path.insert(0, './deps')
import yt_dlp

def lambda_handler(event, context):
    try:
        url = event['pathParameters']['proxy']
        ydl_opts = {
            'dumpjson': True,
            'geo_bypass': True,
            'no_call_home': True,
            'skip_download': True,
            'verbose': True,
            'extract_flat': 'in_playlist', # FIXME: is this enough? should it be True?
        }
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            data = ydl.extract_info(url, download=False)
        return {
            'statusCode': 200,
            'body': json.dumps(data),
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            }
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)}),
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            }
        }
