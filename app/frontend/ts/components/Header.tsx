import * as React from 'react'
import styled from 'styled-components'

const HeaderWrapper = styled.div`
top: 0;
width: 100%;
height: 2rem;
color: #fff;
background-color: rgba(0, 0, 0, 0.7);
position: fixed;
`

export const Header: React.FC = () => {
  return(
    <HeaderWrapper>
      ぱちお診断
    </HeaderWrapper>
  )
}