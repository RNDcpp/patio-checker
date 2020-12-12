import * as React from 'react'
import styled from 'styled-components'

const DocumentTextLabel = styled.span`
font-size: 2em;
font-family: 'Kosugi Maru', sans-serif;
color: #4e2e19;
`

const ResultPointLabel = styled.span`
font-size: 3em;
text-shadow: ${props => props.theme.fontShadow};
color: ${props => props.theme.color};
font-family: 'Russo One', sans-serif;
`

const RemarkablePointLabelThemeProps = {
  fontShadow: ' #4aff53 1px 0 0.2em',
  color: '#ff9100'
}

const NormalPointLabelThemeProps = {
  fontShadow: ' #a3ffc2 1px 0 0.2em',
  color: '#000000'
}

const BadPointLabelThemeProps = {
  fontShadow: ' #3a3a3a 1px 0 0',
  color: '#4e567e'
}

const ResultTextWrapper = styled.div`
border-bottom: rgba(0, 0, 0, 0.3);
border-style: solid;
border-width: 0px 0px 1px 0px;
`

const Title = styled.div`
width: 99%;
border-left: solid;
border-left-width:6px;
border-left-color: rgba(16,255,55,0.3);
border-bottom: solid;
border-bottom-width: 2px;
border-bottom-color: rgba(0,0,0,0.1);
box-shadow:rgba(250,250,250,0.3) 0 2px 0;
font-size: 1.2em;
margin: 0px 0px 0px 0px;
`

interface resultProps{
  visible: boolean,
  document: string,
  point: number
}

export const ResultText: React.FC<resultProps> = (props) => {
  const pointLabelTheme = (point: number) => {
    if(point > 90){
      return RemarkablePointLabelThemeProps
    }else if(point > 30){
      return NormalPointLabelThemeProps
    }else{
      return BadPointLabelThemeProps
    }
  }
  if(props.visible){
    return(
      <ResultTextWrapper>
        <DocumentTextLabel>『{props.document}』</DocumentTextLabel>
        <label>のぱちお度は...</label>
        <ResultPointLabel theme={pointLabelTheme(props.point)}>{props.point}%</ResultPointLabel>
        <label>でした</label>
      </ResultTextWrapper>
    )
    }else{
      return(
        <div>
          <Title>ぱちお診断とは？</Title>
          <p>
						<p>ナイーブベイズフィルタリングのアルゴリズムを用いて実装されたぱちお判別システムです。</p>
						<p>みんなのアイドルぱちお(<a href="https://twitter.com/patioglass">＠patioglass</a>)くんのツイートを訓練データとして<br/>
							入力された文章からぱちお度を算出します。
            </p>
          </p>
        </div>
      )
    }
}