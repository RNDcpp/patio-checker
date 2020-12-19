import * as React from 'react'
import styled from 'styled-components'

interface tweetButtonProps {
  doc: string,
  point: number
}

declare global {
  interface Window {
    twttr?: any;
  }
}

const TBtn = styled.a`
background-color: #1DA1F2;
color: #fff;
padding: 0.5rem;
text-decoration: none;
display: inline-block;
margin-right: 3rem;
border: solid;
border-left-color:  #c9eaff;
border-top-color: #c9eaff;
border-bottom-color: #007ccf;
border-right-color: #0067a7;
border-width: 1px;
`

const SharePane = styled.div`
display: flex;
justify-content: flex-end;
padding: 0.5rem;
border-top: solid;
border-width: 1px;
border-color: rgba(255, 255, 255, 0.5);
`

export const TweetButton: React.FC<tweetButtonProps> = (props) => {
  const wrappedText = (doc:string, point:number) => `『${doc}』のぱちお度は${point}%でした。
  `
  const url = `https://twitter.com/intent/tweet?url=${encodeURI('https://ぱちお.com')}&text=${encodeURI(wrappedText(props.doc, props.point))}&hashtags=${encodeURI('ぱちお診断')}`
  return(
    <SharePane>
      <TBtn
        href={url}
        className="twitter-share-button"
        target="_blank"
      >Tweet</TBtn>
    </SharePane>
  )
}